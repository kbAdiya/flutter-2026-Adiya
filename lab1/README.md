# lab1

# Dance Workshops — Flutter Lab 1

## About the App

Dance Workshops is a Flutter application for browsing and joining dance classes. Users can explore workshops, search by title, filter by dance category, and add workshops to favourites.

The app also allows users to create, edit, and delete workshops. Each workshop has a title, category, date, place, participant limit, and optional description.

Users can enter their name and group in the Profile tab, join or leave workshops, and switch between light, dark, and system themes.

All data is stored in memory. The application does not use a database, network API, or additional packages.


## Decisions

1. I keep the workshop list and user profile in the Shell State because all three tabs need access to this data.
2. I pass data to child widgets through constructors and use callbacks to update the parent state.
3. The Detail Screen receives callbacks so it can update or delete a workshop without storing the main list itself.
4. The Form Screen returns a Workshop using Navigator.pop, and the previous screen receives the result using await pushNamed.
5. I use LayoutBuilder to show a ListView on phones and a GridView on wider screens.
6. PopScope compares the current form values with the original values to check for unsaved changes before leaving.
7. With the tools from week 9, I would consider moving shared state into ChangeNotifier instead of managing it with callbacks and setState.