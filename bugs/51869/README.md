# JMeter Bug [51869](https://bz.apache.org/bugzilla/show_bug.cgi?id=51869)


## Patch

```diff
t@tiger-812:/code/jmeter/src/jmeter$ git show 4e86ce3b77a5bfe684e841c31ffa2ceb0e0ebcf3
commit 4e86ce3b77a5bfe684e841c31ffa2ceb0e0ebcf3
Author: Sebastian Bazley <sebb@apache.org>
Date:   Thu Sep 22 17:12:22 2011 +0000

    Bug 51869 - NullPointer Exception when using Include Controller
    
    git-svn-id: https://svn.apache.org/repos/asf/jakarta/jmeter/trunk@1174269 13f79535-47bb-0310-9956-ffa450edef68

diff --git a/src/components/org/apache/jmeter/control/IncludeController.java b/src/components/org/apache/jmeter/control/IncludeController.java
index 8f36678..f4dbff0 100644
--- a/src/components/org/apache/jmeter/control/IncludeController.java
+++ b/src/components/org/apache/jmeter/control/IncludeController.java
@@ -78,7 +78,7 @@ public class IncludeController extends GenericController implements ReplaceableC                                                                                                                                                                             
                 }                                                                                                                                                                                                                                                             
             }                                                                                                                                                                                                                                                                 
             clone.SUBTREE = (HashTree)this.SUBTREE.clone();                                                                                                                                                                                                                   
-            clone.SUB = (TestElement)this.SUB.clone();                                                                                                                                                                                                                        
+            clone.SUB = this.SUB==null ? null : (TestElement) this.SUB.clone();                                                                                                                                                                                               
         }                                                                                                                                                                                                                                                                     
         return clone;                                                                                                                                                                                                                                                         
     }                                                                                                                                                                                                                                                                         
diff --git a/xdocs/changes.xml b/xdocs/changes.xml                                                                                                                                                                                                                             
index 47824a2..12d1886 100644                                                                                                                                                                                                                                                  
--- a/xdocs/changes.xml                                                                                                                                                                                                                                                        
+++ b/xdocs/changes.xml                                                                                                                                                                                                                                                        
@@ -106,6 +106,7 @@ This can be overridden by setting the JMeter property <b>httpclient4.retrycount<                                                                                                                                                                           
 <ul>                                                                                                                                                                                                                                                                          
 <li>If Controller - Fixed two regressions introduced by bug 50032 (see bug 50618 too)</li>                                                                                                                                                                                    
 <li>If Controller - Catches a StackOverflowError when a condition returns always false (after at least one iteration with return true) See bug 50618</li>                                                                                                                     
+<li>Bug 51869 - NullPointer Exception when using Include Controller</li>                                                                                                                                                                                                      
 </ul>                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                               
 <h3>Listeners</h3>    
```
