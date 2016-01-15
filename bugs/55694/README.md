# JMeter Bug [55694](http://bz.apache.org/bugzilla/show_bug.cgi?id=55694)

## Patch

If `matchStrings` does not throw an exception, a pre-allocated empty `ArrayList` will be returned finally.

Check the commit [here](http://svn.apache.org/viewvc?view=revision&revision=1535130).

```diff
--- jmeter/trunk/src/components/org/apache/jmeter/extractor/RegexExtractor.java	2013/10/23 19:35:17	1535129
+++ jmeter/trunk/src/components/org/apache/jmeter/extractor/RegexExtractor.java	2013/10/23 19:37:55	1535130
@@ -20,6 +20,7 @@
 
 import java.io.Serializable;
 import java.util.ArrayList;
+import java.util.Collections;
 import java.util.List;
 
 import org.apache.commons.lang3.StringEscapeUtils;
@@ -194,6 +195,10 @@
 
         if (isScopeVariable()){
             String inputString=vars.get(getVariableName());
+            if(inputString == null) {
+                log.warn("No variable '"+getVariableName()+"' found to process by RegexExtractor "+getName()+", skipping processing");
+                return Collections.emptyList();
+            }
             matchStrings(matchNumber, matcher, pattern, matches, found,
                     inputString);
         } else {
```

