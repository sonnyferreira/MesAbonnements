# Mes Abonnements — app iOS sans Mac

App SwiftUI pour suivre vos abonnements. La V1 comprend l'ajout d'un abonnement, la liste et le total mensuel et annuel.
Elle est compilée gratuitement par GitHub, puis installée depuis Windows avec Sideloadly et un Apple ID gratuit (certificat de 7 jours).

## Contenu du dossier

| Fichier | Rôle |
|---|---|
| `MesAbonnements/MesAbonnementsApp.swift` | Tout le code de l'app |
| `project.yml` | Décrit le projet Xcode (généré sur le serveur) |
| `.github/workflows/build-ipa.yml` | Compile l'app et produit le `.ipa` |

---

## Étape 1 — Mettre le code sur GitHub (une seule fois)

1. Créez un compte gratuit sur https://github.com.
2. Cliquez sur **New repository**, nommez-le `MesAbonnements` et choisissez **Public**.
   Les minutes de compilation macOS sont gratuites et illimitées pour un dépôt public. En privé, vous auriez environ 40 compilations par mois.
3. Installez **GitHub Desktop** (https://desktop.github.com), puis connectez-vous.
4. Dans GitHub Desktop, faites **File → Clone repository** et choisissez `MesAbonnements`.
5. Copiez **tout le contenu** de ce dossier dans le dossier cloné, y compris le dossier `.github`.
   Dans l'Explorateur Windows, il faut parfois cocher **Affichage → Éléments masqués** pour le voir.
6. Dans GitHub Desktop, écrivez un message (ex. « V1 »), cliquez sur **Commit to main**, puis sur **Push origin**.

## Étape 2 — Récupérer le fichier .ipa

1. Sur la page du dépôt GitHub, ouvrez l'onglet **Actions**.
2. La compilation « Compiler le fichier .ipa » démarre toute seule et dure environ 5 minutes. Attendez la coche verte ✅.
3. Cliquez dessus. En bas, dans **Artifacts**, téléchargez `MesAbonnements-ipa`.
4. Dézippez-le : vous obtenez `MesAbonnements.ipa`.

Pour relancer une compilation sans rien modifier, ouvrez **Actions**, choisissez « Compiler le fichier .ipa » et cliquez sur **Run workflow**.

## Étape 3 — Préparer le PC et l'iPhone (une seule fois)

1. Sur le PC, installez **Appareils Apple** depuis le Microsoft Store, ou iTunes, pour que l'iPhone soit reconnu en USB.
2. Installez **Sideloadly** depuis https://sideloadly.io.
3. Branchez l'iPhone et répondez **Se fier à cet ordinateur**.

## Étape 4 — Installer l'app

1. Ouvrez Sideloadly. Votre iPhone apparaît dans la liste.
2. Glissez `MesAbonnements.ipa` dans la fenêtre.
3. Entrez votre Apple ID dans le champ prévu, puis cliquez sur **Start** et saisissez le mot de passe et le code de double authentification quand ils sont demandés.
   Un Apple ID secondaire, créé exprès, fonctionne aussi si vous préférez.
4. Sur l'iPhone :
   - **Réglages → Confidentialité et sécurité → Mode développeur** : activez-le. L'iPhone redémarre ; confirmez ensuite.
   - **Réglages → Général → VPN et gestion de l'appareil** : touchez votre Apple ID, puis **Faire confiance**.
5. Ouvrez l'app « Abonnements ». 🎉

## Tous les 7 jours

L'app refuse de s'ouvrir quand le certificat expire. Rebranchez l'iPhone et relancez Sideloadly avec le même `.ipa`.
**Vos abonnements enregistrés sont conservés**, tant que vous ne supprimez pas l'app.

## Modifier l'app

Modifiez `MesAbonnementsApp.swift`, faites **Commit** et **Push** dans GitHub Desktop, puis attendez la compilation. Téléchargez le nouveau `.ipa` et réinstallez-le avec Sideloadly.

## En cas de problème

- **Croix rouge ❌ dans Actions** : cliquez sur l'étape en échec, copiez le message d'erreur et envoyez-le à Claude.
- **Sideloadly ne voit pas l'iPhone** : vérifiez qu'Appareils Apple ou iTunes est installé, déverrouillez l'iPhone et changez de câble ou de port USB.
- **« Maximum number of apps »** : le compte gratuit est limité à 3 apps installées de cette façon. Supprimez-en une.
