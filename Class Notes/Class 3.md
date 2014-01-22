## Class 3 - 1/21/14

## Homeworks
### TODO HW

* Don't need to check if cell is nil.
* If using different types of cells, replace **CellIdentifier** with a matching identifier (Text, Video, etc)    
`[tableView dequeueReusableCellWithIdentifier:CellIdentifier]`

### Twitter HW

* Dynamic height table rows are difficult.
* Even if you wait for a POST request to complete, there's no guarantee that you will see what you have just posted if you put in a GET request right afterwards.

## Class

### Networking

* **NSURLConnection** - Executes requests and calls a completionHandler when done.
* **NSURLCache** - Have to configure cache manually for it to actually work.
* Use **AFNetworking** for thread pooling to avoid overloading network requests. It also provides image caching and other fun features.

### Authentication

* OAuth 1.0a uses HTTP. OAuth 2.0 requires HTTPS.
* iOS 6 includes **Social Framework** which integrates social networking services like Facebook and Twitter. 

### Persistence

* **NSCoding** - Protocol for object serialization. 
	* `- (id)initWithCoder:(NSCoder *)decoder;`
	* `- (void)encodeWithCoder:(NSScoder *)encoder;`
* Alternately, use JSON for serialization.
* **NSUserDefaults** - Used for simple persistence of small number of things (e.g., app state, logged-in user). 
* **File I/O** - Each app has its own space for documents and cache on the file system.
* **SQLite** - Lightweight embedded SQL programming. (Not recommended except for certain sistuations)
* **Core Data** - Powerful framework for object management and persistence. (Often too powerful to be efficient)

### Multithreading

* iOS uses an event queue, which just keeps poping off the first element in the queue. If computations are done on the main thread, the event queue will not progress until the computing event is finished (new events are still added to the queue). 
* All UI operations (**UIKit**) must happen on the main thread. 
	* Performing UI operations on a non-main thread is nondeterministic. It may work, or it may crash unexpectedly. 
	* It's OK to perform UI operations on a completionHandler in   
	`[NSURLConnection sendAsynchronousRequest]`
* Threading Options
	* **performSelectorInBackground** - Easy to use.
		* **performSelectorOnMainThread** - Switch back to main thread.
	* **NSOperation & NSOperationQueue** - Comparable to Runnable
		* Can monitor status of operations in queue. 
		* Can establish dependencies between operations. 
		* Can set max # of concurrent operations.
	* **Blocks & Grand Central Dispatch (GCD)**
		1. Choose dispatch queue - create a dispatch queue or use one of the built-in dispatch queues.
		2. Create a block - wrap the desired functionality in a block.
		3. Choose sync or async - add the block to the queue and execute it either sync or async.
	* **Timers**
	
### Offline Twitter Client

#### Storage
* Writes images to disk (twitter/images)
* Write payload JSON to disk (twitter/home_timeline.json)
* 



## General Notes
* When using **parseForKeyPath** for JSON parsing, you can use dot notation for deeply nested keys (e.g., results.movies.actor or something).
* **Clip Subviews ** - Prevent children from exceed the bounds of their parents