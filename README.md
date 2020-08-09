# Color-induced-pixel-sort
Processing program with color boosting for pixel sort

Files must be placed in a folder with the same name as that of the pde file

/*

 Color induced Pixel Sort by AKTracer ver 1.0, 9 Aug 2020
 Built for Processing 3
 Based on ASDF Pixel sort by Kim Asendorf
 
 https://instagram.com/tay.glitch
 https://instagram.com/aktracer
 
  Instructions:
* Put file name and file extension
* Set direction to horizontal or vertical
* Set mode of sorting, black, brightness or white

  Tips
* Set corresponding threshold to control how much area is affected
* Set reverseMode to true to reverse the direction of pull

  How to color the sort
* You can play with the value of "steroids" variable, which induces color in the sorted area
* Some interesting values are provided in the comments
* To find where they are do a ctrl+F(cmd+F for mac) and find three stars "***"
* if in vertical mode, steroids should be adjusted in sortColumn() function
  if in horizontal mode, the steroids in sortRow() must be adjusted
  For no coloration, set steroids to 0
  
 HSB shift
* The colors already boosted can be shifted in hue, sat, bri overall
* Search for four stars to find quickly the variables new_hue, new_sat. new_bri
  and play with them. these are functions of y or x variables depending on row or column mode
 
 Notes
* The direction of sort may change when sorting mode is changed, ex. black, brigheness, white mode
* Because we are operating on one pixel at a time, the "steroids" and the "new_" etc.
  variables cannot be conveniently placed on top, else the pixel cannot be accessed that way
  It is possible to perform a three star or four star find operation to quickly access them
  either within the sortColumn() or sortRow() functions, depending upon the direction
  vertical means column and horizontal means row mode
* File names and file extensions are case sensitive, mistyping them is the most common error
  
* If you have a solution to how the coloration can be done in real time, please write to me at
arjunkhode [at] gmail
 
 */
