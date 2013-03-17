asynchronousTestingHelper
=========================

Category for Asynchronous Testing

How to use:

Copy the NSObject+BackgroundOperation category/header to your Xcode project

Whenever you are doing a background-thread operation with an object where you'd like to test the result after it's finished, use the performBackgroundOperation method.

Then, in your tests, call waitForBackgroundOperations on the relevant object.

Included are a demo app and demo tests.

License
=========================

This project is covered by the MIT License:
http://opensource.org/licenses/MIT