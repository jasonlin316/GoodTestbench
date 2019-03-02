GoodTestbench
=============
This test bench contains some of the most well know memes on the internet.
The text art pop up after each simulation and the pattern depends on the situation you run into.
You can use the SET.v to try this testbench out.

More Than 10 Errors:
-------------------
![image](https://github.com/jasonlin316/GoodTestbench/blob/master/Screenshots/anger.gif)

Note: If want to edit the the amount of error that the testbench can tolerate, simply change the  IF condition "(err_cnt == 10)" to a different number in line 141 of textfixture.v 

Simulation Passed:
-------------
![image](https://github.com/jasonlin316/GoodTestbench/blob/master/Screenshots/pica.gif)

Cycle Limit Exceeds:
----------------
![image](https://github.com/jasonlin316/GoodTestbench/blob/master/Screenshots/sunglasses.gif)

Note: The situation occurs when your simulation runs too long, exceeding a certain number of cycles. You can edit this in line 4 of testfixture, "`define terminate_cycle 200000".

Error Occured:
-------------------------
![image](https://github.com/jasonlin316/GoodTestbench/blob/master/Screenshots/troll.gif)


Reference
---------------
[1]http://textart4u.blogspot.com
[2]https://www.reddit.com/r/ProgrammerHumor/comments/a381ur/the_correct_reaction_to_unit_tests_passing/
