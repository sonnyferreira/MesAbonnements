// MesAbonnements — Version 1
// Formulaire d'ajout, liste des abonnements, total en bas de l'écran.
// Sauvegarde locale sur le téléphone avec SwiftData (iOS 17+).

import SwiftUI
import SwiftData

// MARK: - Modèle

enum Frequence: String, CaseIterable, Identifiable {
    case mensuelle = "Mensuelle"
    case annuelle = "Annuelle"
    var id: String { rawValue }
}

@Model
final class Abonnement {
    var nom: String
    var prix: Double
    var frequenceRaw: String
    var dateRenouvellement: Date

    init(nom: String, prix: Double, frequence: Frequence, dateRenouvellement: Date) {
        self.nom = nom
        self.prix = prix
        self.frequenceRaw = frequence.rawValue
        self.dateRenouvellement = dateRenouvellement
    }

    var frequence: Frequence {
        get { Frequence(rawValue: frequenceRaw) ?? .mensuelle }
        set { frequenceRaw = newValue.rawValue }
    }

    /// Coût ramené au mois (un abonnement annuel est divisé par 12).
    var coutMensuel: Double {
        frequence == .mensuelle ? prix : prix / 12
    }
}

// MARK: - App

@main
struct MesAbonnementsApp: App {
    var body: some Scene {
        WindowGroup {
            ListeAbonnementsView()
        }
        .modelContainer(for: Abonnement.self)
    }
}

// MARK: - Liste + total

struct ListeAbonnementsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Abonnement.dateRenouvellement) private var abonnements: [Abonnement]
    @State private var afficherFormulaire = false

    private var totalMensuel: Double {
        abonnements.reduce(0) { $0 + $1.coutMensuel }
    }

    var body: some View {
        NavigationStack {
            Group {
                if abonnements.isEmpty {
                    ContentUnavailableView(
                        "Aucun abonnement",
                        systemImage: "creditcard",
                        description: Text("Touchez + pour ajouter votre premier abonnement.")
                    )
                } else {
                    List {
                        ForEach(abonnements) { abo in
                            LigneAbonnement(abonnement: abo)
                        }
                        .onDelete(perform: supprimer)
                    }
                }
            }
            .navigationTitle("Mes abonnements")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        afficherFormulaire = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $afficherFormulaire) {
                AjoutAbonnementView()
            }
            .safeAreaInset(edge: .bottom) {
                BarreTotal(mensuel: totalMensuel)
            }
        }
    }

    private func supprimer(at offsets: IndexSet) {
        for index in offsets {
            context.delete(abonnements[index])
        }
    }
}

struct LigneAbonnement: View {
    let abonnement: Abonnement

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(abonnement.nom)
                    .font(.headline)
                Text("Renouvellement : \(abonnement.dateRenouvellement.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(abonnement.prix, format: .currency(code: "EUR"))
                    .font(.body.monospacedDigit())
                Text(abonnement.frequence.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct BarreTotal: View {
    let mensuel: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Total par mois").font(.caption).foregroundStyle(.secondary)
                Text(mensuel, format: .currency(code: "EUR"))
                    .font(.title2.bold().monospacedDigit())
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Total par an").font(.caption).foregroundStyle(.secondary)
                Text(mensuel * 12, format: .currency(code: "EUR"))
                    .font(.title3.monospacedDigit())
            }
        }
        .padding()
        .background(.regularMaterial)
    }
}

// MARK: - Formulaire d'ajout

struct AjoutAbonnementView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var nom = ""
    @State private var prix: Double?
    @State private var frequence: Frequence = .mensuelle
    @State private var date = Date()

    private var formulaireValide: Bool {
        !nom.trimmingCharacters(in: .whitespaces).isEmpty && (prix ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Service") {
                    TextField("Nom (ex. Netflix)", text: $nom)
                    TextField("Prix", value: $prix, format: .currency(code: "EUR"))
                        .keyboardType(.decimalPad)
                }
                Section("Facturation") {
                    Picker("Fréquence", selection: $frequence) {
                        ForEach(Frequence.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    DatePicker("Prochain prélèvement", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Nouvel abonnement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let abo = Abonnement(
                            nom: nom.trimmingCharacters(in: .whitespaces),
                            prix: prix ?? 0,
                            frequence: frequence,
                            dateRenouvellement: date
                        )
                        context.insert(abo)
                        dismiss()
                    }
                    .disabled(!formulaireValide)
                }
            }
        }
    }
}
