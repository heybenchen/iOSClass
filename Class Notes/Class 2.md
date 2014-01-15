## Class 2 - 1/14/14  
	  
# Rotten Tomatoes (cont.)

#### Storyboard Method

* **Push** - opens a new view from the right with backwards navigation  

	* Nav bar shows automatically.  
	
* **Modal** - opens a new view that comes from the bottom  and appears above the current view. 

	* Can add navigation bar manually : *Editor > Embed In > Navigation Controller*. This keeps the navigation stack. 
	
	* Add close button and add "action" to **onCloseButton**() in **MovieItemViewController** that calls  
		`[self dismissViewControllerAnimated:YES completion:nil];	`
	
* Cells should open the new view from the segue method

####Interface Builder Method

* *New Class > User Interface > View* : **MovieItemViewController**
* Initialize manually in **didSelectRowAtIndexPath**()

		MovieItemViewController * vc = [[MovieItemViewController alloc] init];
		vc.model = [self.movies get:indexPath.row];
		
		UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
		[self presentViewController:nvc animated:YES completion:nil];
		
#### AutoLayout

1. Add the constraints you want.
2. Click **Add Missing Constraints**.
3. If you move the view: 
	* **Update All Frames** - adjust the view to match constraints
	* **Update All Constraints** - adjust the constraints to match view
4. Fix all yellow constraints (blue is good).

		
#### General Notes

Assigning Variables:

* **strong** for objects
* **assign** for primatives
* **weak** for delegates and IBOutlets