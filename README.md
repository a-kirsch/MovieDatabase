# MovieDatabase
iOS application powered by tMDB for finding movies, with capabilities for favorites and watchlist.


# Design Decisions
1. Search executes on enter rather than text did change because it was less sensible for the app to execute a call and search every time a new letter was typed. While the autocomplete seems nice it ultimately slowed down the app to the point that photos and titles would get out of sync so to search just type the search term and press enter.

# Creative Portion

1. Expand to detail view by tapping on the favorite cell of the table view. This was a crucial feature to add for the user experience because when they are in the favorites tab all of the movie information is squeezed onto a small cell that will almost always have the outline of the movie cutoff leaving users wanting to see more. As seen from the demo in class a natural function of a tableview is tapping on a cell and expanding to a page with more information. To create this functionality I added a navigation view before the view controller. Then within the FavoriteViewController I utilized the didSelectRowAtPath functionality and created the view with the specific identifier. Then I passsed the information about the image and movie with into the detailviewcontroller with its variables and then pushed the detailviewcontroller.

2. Add to watchlist. Users will utilize this app to search for movies they are interested in watching. Adding to a watchlist is a natural addition to the app for users to save movies they want to watch for later. This was created by adding a button to the detail view controller for adding to watchlist. Then I created an additional view controller segued from my tab view to the WatchlistViewController. This tableview got the data from a statecontroller view which has arrays to store the cached images of the watchlist and the movies themselves. Then the watchlist view controller displays a table view with all of the information required from favorites.

3. Watchlist can also expand to detail view by tapping on the watchlist cell of the table view. This was a natural next step of adding the watchlist. To impliment this navigation I added the navigation controller before the view controller with my watchlist table view. Again within the WatchlistViewController I utilized the didSelectRowAtPath functionality and created the view with the detail identifier. Then I passsed the information about the image and movie with into the detailviewcontroller with its variables and then pushed the detailviewcontroller.

4. Added a clear favorites button to favorites and watchlist. If the user would like to reset the lists on their account they should have that option without needing to slide and tap over every movie in these lists. To impliment this I added a button to the corner of each of these views. When pressed, the state controller arrays will reset to empty arrays and then call resetData() on the table views.

5. Review scores are rounded on the detail view. When we see scores on websites and apps in the world they would never be given to the second, third, or fourth decimal place. Because of this I decided to display average movie ratings to the first decimal place. This was done by multiplying the rating by 10 and rounding then converting back into a double before dividing by 10. This displays below the release date on my detail view controller.

6. Add to favorites and add to watchlist button cannot be used more than once and the text on the button updates to inform the user whether the movie is already on a certain list. When a user searches a movie and is on the detail page of that movie it is important that they can see what the status is of the movie in regards to the lists they can add it to. This is done with a boolean favorited and watchlisted for the watchlist and favorite. When the view will appear the variables are initialized as false and then the favorites and watchlist state controller is iterated through and searching for an instance of the movie that we have pushed onto the detail view controller. If the movie is on a list then the boolean is switched to true and the button text is changed to 'One of your favorites' or 'On your watchlist'. Then when the buttons are pressed before adding to these arrays there is a check for these booleans to make sure there are no duplicates on this list. When a cell is the reset to false will take place automatically. I considered implimenting a preventative method for movies to be added to favorites and watchlist but because users may put a favorite on their watchlist as something they have not seen in a while they want to rewatch I decided against it.

7. Passing information between controllers utilized a state controller. This was a safer way to pass data between tab views. It is safer as the user defaults has limits to the amount of data it could store. State controller easily manages data that needs to be in all three tab views.

8. Expand the description. Many of the movie descriptions are long and get truncated on the detail view controller. The users will likely want to read the entire thing and because of this we need a way to expand the description. To do this I added an additional view controller which is pushed on when expand description is called.

9. Suggestions tab view. The app has access to all movies in the movie database but before adding the suggestions tab users could only find movies by search. A natural addition to the app is a way for users to find new movies so I implimented a new navigation view on the tab bar that has the root with a table view for recommendations. Every time we are on this tab a new 20 movies populates to the user and they can see the title, poster, and description with the option to expand by tapping on the cell and seeing the entire detail view of the movie. To create this I searched 500 pages of the movie data base when the view will appear and I randomize and take 20 movies off of any of those pages. I add cells to my table view with images that are cached and title and description from the suggestions array.

10. Favorites table view and watchlist table view display movie poster and description as well as movie titles, all favorite and watchlist posters are cached. This gives the tab a bit more of a visual for the user to see their in favorites and watchlist. To do this I created the cells specifically with the type .subtitle and added the movie description from the favorites array into each cell. Additionally I cached the images of all favorites and watchlists so I would not need to make another call and could just add them straight to the cells.

11. Favorite Images are saved over user defaults. This was a difficult one to impliment as the images are not of the codable type. But to do this I saved the id with .png and then added to an array to store over user defaults. This was a necessary addition because I wanted the favorites table view to have these posters and they needed to be pulled up on every relaunch with the storing favorites requirement of the lab.

12. Saving favorite images and favorite movie information in User Defaults allows favorites list to display without wifi. The API call is never needed on these pages and the lists will always be stored for the user when they open the app.

# Extra Credit

1. Submitted the studio on canvas.

2. Added a 3d touch action menu. Users can add movies to favorites, to the watchlist, and view the detailed view of the movie by holding down on a cell with 3d touch and then selecting these options.

