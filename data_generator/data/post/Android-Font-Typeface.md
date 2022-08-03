---
title: Android Font Typeface
date: 2016-09-19 17:00:23
tags:
---

Android 官方Typeface：Droid sans, Droid Sans Mono, Droid Serif, Default sans

TextStyle: normal, bload, italic

##### 常用Spannable类
	
	字体颜色：ForegroundColorSpan
	字体背景颜色：BackgroundColorSpan
	字体大小：AbsoluteSizeSpan
	粗体，斜体：StyleSpan
	删除线：StrikeThroughSpan
	下划线：UnderlineSpan
	图片：ImageSpan
	字体：TypefaceSpan
	自定义字体：class CustomTypefaceSpan extends TypefaceSpan

使用方法

```java
SpannableString spanString = new SpannableString("xxxxx");    
StyleSpan span = new StyleSpan(Typeface.BOLD_ITALIC);    
spanString.setSpan(span, 1, 3, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);    
textView.setText(spanString);   
```


##### `setTypeface`设置自定义字体

```java
TextView txt = (TextView) findViewById(R.id.custom_font);
Typeface font = Typeface.createFromAsset(getAssets(), "Chantelli_Antiqua.ttf");
txt.setTypeface(font);
```

##### `CustomeTypefaceSpan`设置自定义字体

使用

```java
Typeface typeface = Typeface.createFromAsset(getAssets(), "Akshar.ttf");
SpannableString str = new SpannableString("hello world");
str.setSpan(new CustomTypefaceSpan("", typeface), 0, string.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
```

CustomeTypefaceSpan.java

```java
public class CustomTypefaceSpan extends TypefaceSpan {

private final Typeface newType;

public CustomTypefaceSpan(String family, Typeface type) {
    super(family);
    newType = type;
}

@Override
public void updateDrawState(TextPaint ds) {
    applyCustomTypeFace(ds, newType);
}

@Override
public void updateMeasureState(TextPaint paint) {
    applyCustomTypeFace(paint, newType);
}

private static void applyCustomTypeFace(Paint paint, Typeface tf) {
    int oldStyle;
    Typeface old = paint.getTypeface();
    if (old == null) {
        oldStyle = 0;
    } else {
        oldStyle = old.getStyle();
    }

    int fake = oldStyle & ~tf.getStyle();
    if ((fake & Typeface.BOLD) != 0) {
        paint.setFakeBoldText(true);
    }

    if ((fake & Typeface.ITALIC) != 0) {
        paint.setTextSkewX(-0.25f);
    }

    paint.setTypeface(tf);
}
}

```

[How set Spannable object font with custom font](http://stackoverflow.com/questions/6612316/how-set-spannable-object-font-with-custom-font)


##### 自定义字体可能导致的问题

1. Ellipsizing might not work correctly if the font dosen't have a glyph for ellipsis character（没有省略字符的话导致肾略效果失效）
2. internationalization might not be supported（可能对国际化，多语言不支持）
3. 增加了apk的体积

老版本的new TypeFace()会存在内存泄漏,此bug在Android 3.2上已fixed

处理内存泄漏fix方案：

```java
public class FontCache {

    private static Hashtable<String, Typeface> fontCache = new Hashtable<String, Typeface>();

    public static Typeface get(String name, Context context) {
        Typeface tf = fontCache.get(name);
        if(tf == null) {
            try {
                tf = Typeface.createFromAsset(context.getAssets(), name);
            }
            catch (Exception e) {
                return null;
            }
            fontCache.put(name, tf);
        }
        return tf;
    }
}
```

http://stackoverflow.com/questions/16901930/memory-leaks-with-custom-font-for-set-custom-font/16902532#16902532  
https://code.google.com/p/android/issues/detail?id=9904  


##### Typeface源码

Typeface.create()方法返回的Typeface是存在缓存的

```java
	public static Typeface create(String familyName, int style) {
        if (sSystemFontMap != null) {
            return create(sSystemFontMap.get(familyName), style);
        }
        return null;
    }orm
    
    public static Typeface create(Typeface family, int style) {
    	 Typeface typeface;
    	 //private static final LongSparseArray<SparseArray<Typeface>> sTypefaceCache = new LongSparseArray<SparseArray<Typeface>>(3);
        SparseArray<Typeface> styles = sTypefaceCache.get(ni);

        if (styles != null) {
            typeface = styles.get(style);
            if (typeface != null) {
                return typeface;
            }
        }
    }
```

但是`public static Typeface createFromAsset(AssetManager mgr, String path)`创建的Typeface好像不存在缓存，反正代码是没看懂

[Does Typeface.createFromAsset() cache?](http://stackoverflow.com/questions/4320090/does-typeface-createfromasset-cache)

测试加载一个8M的字体文件耗时100ms,200kb的字体文件20ms

##### String.format()格式化时保留SpannableString 样式

默认的情况下String.format()传入的SpannableString会当做普通的String处理，不会保留SpannableString中字体，样式等特性

```java
/**
 * 
 * @author George T. Steel
 *
 */
public class SpanFormatter {
	public static final Pattern FORMAT_SEQUENCE	= Pattern.compile("%([0-9]+\\$|<?)([^a-zA-z%]*)([[a-zA-Z%]&&[^tT]]|[tT][a-zA-Z])");
	
	private SpanFormatter(){}
	
	public static SpannedString format(CharSequence format, Object... args) {
        return format(Locale.getDefault(), format, args);
    }
	
	public static SpannedString format(Locale locale, CharSequence format, Object... args){
		SpannableStringBuilder out = new SpannableStringBuilder(format);
		
		int i = 0;
		int argAt = -1;
		
		while (i < out.length()){
			Matcher m = FORMAT_SEQUENCE.matcher(out);
			if (!m.find(i)) break;
			i=m.start();
			int exprEnd = m.end();
			
			String argTerm = m.group(1);
			String modTerm = m.group(2);
			String typeTerm = m.group(3);
			
			CharSequence cookedArg;
			
			if (typeTerm.equals("%")){
				cookedArg = "%";
			}else if (typeTerm.equals("n")){
				cookedArg = "\n";
			}else{
				int argIdx = 0;
				if (argTerm.equals("")) argIdx = ++argAt;
				else if (argTerm.equals("<")) argIdx = argAt;
				else argIdx = Integer.parseInt(argTerm.substring(0, argTerm.length() - 1)) -1;
				
				Object argItem = args[argIdx];
				
				if (typeTerm.equals("s") && argItem instanceof Spanned){
					cookedArg = (Spanned) argItem;
				}else{
					cookedArg = String.format(locale, "%"+modTerm+typeTerm, argItem);
				}
			}
			
			out.replace(i, exprEnd, cookedArg);
			i += cookedArg.length();
		}
		
		return new SpannedString(out);
	}
}
```

参考

[Combining Spannable with String.format()](http://stackoverflow.com/questions/20936901/combining-spannable-with-string-format)  
[a version of String.format](https://github.com/george-steel/android-utils/blob/master/src/org/oshkimaadziig/george/androidutils/SpanFormatter.java)
