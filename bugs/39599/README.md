# JMeter Bug [39599](https://bz.apache.org/bugzilla/show_bug.cgi?id=39599)

## Steps

1. Run `run.sh`
2. Press Ctrl+R

## Patch


```
commit 375077643b765271ab35e4bf00532460b2839e05
Author: Sebastian Bazley <sebb@apache.org>
Date:   Thu May 18 21:59:24 2006 +0000

    Bug 39599 - ConcurrentModificationException
    Remove disabled items from loaded tree before returning it
    
    git-svn-id: https://svn.apache.org/repos/asf/jakarta/jmeter/branches/rel-2-1@407643 13f79535-47bb-0310-9956-ffa450edef68

diff --git a/src/components/org/apache/jmeter/control/IncludeController.java b/src/components/org/apache/jmeter/control/IncludeController.java
index cd9983e..3392e60 100644
--- a/src/components/org/apache/jmeter/control/IncludeController.java
+++ b/src/components/org/apache/jmeter/control/IncludeController.java
@@ -19,15 +19,16 @@ package org.apache.jmeter.control;
 
 import java.io.FileInputStream;
 import java.io.FileNotFoundException;
-import java.io.IOException;
 import java.io.InputStream;
 import java.util.Iterator;
+import java.util.LinkedList;
 
 import org.apache.jmeter.save.SaveService;
 import org.apache.jmeter.testelement.TestElement;
 import org.apache.jmeter.util.JMeterUtils;
 import org.apache.jorphan.collections.HashTree;
 import org.apache.jorphan.logging.LoggingManager;
+import org.apache.jorphan.util.JOrphanUtils;
 import org.apache.log.Logger;
 
 /**
@@ -39,12 +40,13 @@ import org.apache.log.Logger;
 public class IncludeController extends GenericController implements ReplaceableController {
 	private static final Logger log = LoggingManager.getLoggerForClass();
 
-    public static final String INCLUDE_PATH = "IncludeController.includepath";
+    private static final String INCLUDE_PATH = "IncludeController.includepath"; //$NON-NLS-1$
 
-    private static  final String prefix;
-    static {
-    	prefix=JMeterUtils.getPropDefault("includecontroller.prefix", "");
-    }
+    private static  final String prefix =
+        JMeterUtils.getPropDefault(
+                "includecontroller.prefix", //$NON-NLS-1$ 
+                ""); //$NON-NLS-1$
+    
     private HashTree SUBTREE = null;
     private TestElement SUB = null;
 
@@ -58,7 +60,9 @@ public class IncludeController extends GenericController implements ReplaceableC
 	}
 
 	public Object clone() {
-        this.loadIncludedElements();
+        // TODO - fix so that this is only called once per test, instead of at every clone
+        // Perhaps save previous filename, and only load if it has changed?
+        this.SUBTREE = this.loadIncludedElements();
 		IncludeController clone = (IncludeController) super.clone();
         clone.setIncludePath(this.getIncludePath());
         if (this.SUBTREE != null) {
@@ -107,13 +111,15 @@ public class IncludeController extends GenericController implements ReplaceableC
         // only try to load the JMX test plan if there is one
         final String includePath = getIncludePath();
         InputStream reader = null;
+        HashTree tree = null;
         if (includePath != null && includePath.length() > 0) {
             try {
             	String file=prefix+includePath;
                 log.info("loadIncludedElements -- try to load included module: "+file);
                 reader = new FileInputStream(file);
-                this.SUBTREE = SaveService.loadTree(reader);
-                return this.SUBTREE;
+                tree = SaveService.loadTree(reader);
+                removeDisabledItems(tree);
+                return tree;
             } catch (NoClassDefFoundError ex) // Allow for missing optional jars
             {
                 String msg = ex.getMessage();
@@ -135,15 +141,24 @@ public class IncludeController extends GenericController implements ReplaceableC
                 log.warn("Unexpected error", ex);
             }
             finally{
-                if (reader!=null){
-                    try {
-                        reader.close();
-                    } catch (IOException e) {
-                    }
-                }
+                JOrphanUtils.closeQuietly(reader);
+            }
+        }
+        return tree;
+    }
+
+    private void removeDisabledItems(HashTree tree) {
+        Iterator iter = new LinkedList(tree.list()).iterator();
+        while (iter.hasNext()) {
+            TestElement item = (TestElement) iter.next();
+            if (!item.isEnabled()) {
+                //log.info("Removing "+item.toString());
+                tree.remove(item);
+            } else {
+                //log.info("Keeping "+item.toString());
+                removeDisabledItems(tree.getTree(item));// Recursive call
             }
         }
-        return this.SUBTREE;
     }
     
 }
```
