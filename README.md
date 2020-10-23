# virtual_white_board

This is a simple whiteboard with functionality for currently two coworkers to upload motivational quotes for each other during a long workday. 
It is possible to extend to memes and fun youtube videos in the future. 
The access to the whiteboard is controlled through the local file 'cuteAD.json'. Here, you'll se that two users have access. When logging in, the username and password is checked to see if they really are valid users. More users can be added.

It is possible for users to only delete their own posts. For example, if they regret "live, love, laugh" and no longer believe this is how life should be lived. 


Download the repository and run the code through web (Chrome). Flutter plugin for your IDE might be needed. This is supported by Android Studio, IntelliJ IDEA and VS Code.

Hack your way through a login (hint: pretend you are either Sam or Bertha whose passwords you can locate in the cuteAD.json file).

Ask to become a moderator, upload a post and watch it appear on the whiteboard to the right, try to delete one of your posts again and watch it disappear again (unfortunately, there are some issues in rendering the dropdown after deleting..but the post is gone). Or change your name to something cooler. 

Unfortunately, the whiteboard's database is down, so posts from one run to another will not be saved.