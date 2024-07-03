# AnyGame

**Stay Connected – Die ultimative App für Gaming-News und -Updates**

AnyGame bietet eine umfassende Plattform für Gaming-Enthusiasten, um die neuesten Nachrichten und Updates zu ihren Lieblingsspielen zu erhalten. Mit einer benutzerfreundlichen Oberfläche und einer Vielzahl an Funktionen, die die Interaktion und Personalisierung ermöglichen, hebt sich AnyGame von anderen Apps ab. 

Egal ob du einfach nur informiert bleiben oder deine Lieblingsspiele im Auge behalten möchtest, AnyGame bietet dir alles, was du brauchst, an einem Ort.

## Geplantes Design
<p>
  <img src="./img/LogIn.png" width="200">
  <img src="./img/Home.png" width="200">
  <img src="./img/Favoriten.png" width="200">
</p>

## Features
Hier kommen alle geplanten Features der App rein mit dem Status, ob es bereits umgesetzt wurde.

- [ ] **LoginView**: Ermöglicht Benutzern die Anmeldung über Firebase-Authentifizierung.
- [ ] **RegisterView**: Ermöglicht Benutzern die Registrierung über Firebase-Authentifizierung.
- [ ] **GameView**: Zeigt eine Übersicht aller Spiele-News in einer Liste und im oberen Bereich einige hervorgehobene Spiele, durch die horizontal gescrollt werden kann. Außerdem enthält sie eine Such- und Filterfunktion.
- [ ] **GameDetailView**: Zeigt detaillierte Informationen zu einem ausgewählten Spiel an, einschließlich Nachrichten und Beschreibungen, und ermöglicht es, das Spiel zu favorisieren.
- [ ] **FavoriteGameView**: Zeigt die favorisierten Spiele an und ermöglicht das Löschen von Favoriten.
- [ ] **ProfileView**: Zeigt das Profil des Benutzers an, ermöglicht das Bearbeiten persönlicher Informationen und das Ausloggen.

## Technischer Aufbau

#### Projektaufbau
Das Projekt folgt dem MVVM (Model-View-ViewModel) Architekturprinzip. Die Hauptordnerstruktur umfasst:

- **Models**: Enthält die Datenmodelle.
- **Views**: Beinhaltet die SwiftUI-Views.
- **ViewModels**: Enthält die Logik und Bindungen zwischen Modellen und Views.
- **Services**: Beinhaltet die Integrationen wie Firebase.

#### Datenspeicherung
- **Firebase**: Für die Authentifizierung und Speicherung von Benutzerinformationen.
- **Core Data**: Für das lokale Speichern von favorisierten Spielen und anderen persistenten Daten.

#### API Calls
- **RAWG API**: Für das Abrufen von Spielinformationen und Nachrichten.

#### 3rd-Party Frameworks
- **Firebase Authentication**: Für Benutzeranmeldung und -registrierung.
- **Firebase Firestore**: Für die Speicherung und Verwaltung der Spieldaten und Benutzerinformationen.
- **SwiftUI**: Für die Gestaltung der Benutzeroberfläche.

## Ausblick
In Zukunft möchte ich eine Community-Funktion integrieren, die es den Benutzern ermöglicht, sich untereinander auszutauschen und zu vernetzen. Diese Funktion wird es den Benutzern ermöglichen, Kommentare zu Spielen und Nachrichten zu hinterlassen und Diskussionen zu führen. Weitere geplante Features werden als Issues erstellt und können dort verfolgt werden.


 
