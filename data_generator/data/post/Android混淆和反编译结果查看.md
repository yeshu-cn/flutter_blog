---
title: Android混淆和反编译结果查看
date: 2020-06-09 10:47:07
tags:
categories: Android
---

源文件
```kotlin
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        Log.i("yeshu", "hello log")
    }
}
```
反编译后到smali文件

```smali
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1

    .line 10
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0a001c

    .line 11
    invoke-virtual {p0, p1}, Lcom/example/logdemo/MainActivity;->setContentView(I)V

    const-string p1, "yeshu"

    const-string v0, "hello log"

    .line 12
    invoke-static {p1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
```

koin转换得到的java文件
```java
@Metadata(bv = {1, 0, 3}, d1 = {"\000\030\n\002\030\002\n\002\030\002\n\002\b\002\n\002\020\002\n\000\n\002\030\002\n\000\030\0002\0020\001B\005\006\002\020\002J\022\020\003\032\0020\0042\b\020\005\032\004\030\0010\006H\024\006\007"}, d2 = {"Lcom/example/logdemo/MainActivity;", "Landroidx/appcompat/app/AppCompatActivity;", "()V", "onCreate", "", "savedInstanceState", "Landroid/os/Bundle;", "app_release"}, k = 1, mv = {1, 1, 16})
public final class MainActivity extends AppCompatActivity {
  private HashMap _$_findViewCache;
  
  public void _$_clearFindViewByIdCache() {
    HashMap hashMap = this._$_findViewCache;
    if (hashMap != null)
      hashMap.clear(); 
  }
  
  public View _$_findCachedViewById(int paramInt) {
    if (this._$_findViewCache == null)
      this._$_findViewCache = new HashMap<Object, Object>(); 
    View view2 = (View)this._$_findViewCache.get(Integer.valueOf(paramInt));
    View view1 = view2;
    if (view2 == null) {
      view1 = findViewById(paramInt);
      this._$_findViewCache.put(Integer.valueOf(paramInt), view1);
    } 
    return view1;
  }
  
  protected void onCreate(Bundle paramBundle) {
    super.onCreate(paramBundle);
    setContentView(2131361820);
    Log.i("yeshu", "hello log");
  }
}

```



## 没有开启混淆优化时

```kotlin
class MainActivity : AppCompatActivity() {
    val debug: Boolean = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        if (debug){
            Log.i("yeshu", "hello log")
        } else {
            Log.i("yeshu", "hello log  true")
        }
    }

    private fun test() {
        Log.i("yeshu", "wo shen me dou mei zuo ")
    }
}
```



* val debug 会让编译器优化掉无效的语句，但是var debug不会。
* 默认的无效方法 test()没有被删除掉


## 开启混淆，优化
启用压缩，优化，混淆后只要逻辑上没执行到的代码就被删除了，依赖库中没用到的代码也都删除了。

```
minifyEnabled true
```



```java
public final class MainActivity extends h {
  public void onCreate(Bundle paramBundle) {
    super.onCreate(paramBundle);
    setContentView(2131361820);
    Log.i("yeshu", "hello log  true");
  }
}
```

```kotlin
class MainActivity : AppCompatActivity() {
    var debug: Boolean = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        if (debug){
            Log.i("yeshu", "hello log")
            test()
        } else {
            Log.i("yeshu", "hello log  true")
        }
    }

    private fun test() {
        Log.i("yeshu", "wo shen me dou mei zuo ")
    }
}
```

test()方法和if判断中的false分支都会被删除



## 子module和主项目之间的混淆配置关系

AAR 库：`<library-dir>/proguard.txt`

JAR 库：`<library-dir>/META-INF/proguard/`



如果某个 AAR 库是使用它自己的 ProGuard 规则文件发布的，并且您将该 AAR 库作为编译时依赖项纳入到项目中，则 R8 在编译项目时会自动应用其规则。

如果 AAR 库需要某些保留规则才能正常运行，那么使用该库随附的规则文件将非常有用。 也就是说，库开发者已经为您执行了问题排查步骤。

不过，请注意，由于 ProGuard 规则是累加的，因此 AAR 库依赖项包含的某些规则无法移除，并且可能会影响对应用其他部分的编译。例如，如果某个库包含停用代码优化的规则，该规则会针对整个项目停用优化

## 查看整个项目的规则

要输出 R8 在构建项目时应用的所有规则的完整报告，请将以下代码添加到模块的 `proguard-rules.pro` 文件中：



```
// You can specify any path and filename.
    -printconfiguration ~/tmp/full-r8-config.txt
```

## 给不同的flavor配置不同的混淆规则

```
android {
        ...
        buildTypes {
            release {
                minifyEnabled true
                proguardFiles getDefaultProguardFile(
                  'proguard-android-optimize.txt'),
                  // List additional ProGuard rules for the given build type here. By default,
                  // Android Studio creates and includes an empty rules file for you (located
                  // at the root directory of each module).
                  'proguard-rules.pro'
            }
        }
        flavorDimensions "version"
        productFlavors {
            flavor1 {
              ...
            }
            flavor2 {
                proguardFile 'flavor2-rules.pro'
            }
        }
    }
    
```

## 自定义要保留的代码

说明了它在什么情况下可能会错误地移除代码：

- 当您的应用通过 Java 原生接口 (JNI) 调用方法时
- 当您的应用在运行时查询代码时（如使用反射）

```
-keep public class MyClass

@Keep
```

## 缩减资源

两个必须同时开启

```
shrinkResources true
minifyEnabled true
```

## 移除未使用的备用资源

以下代码段展示了如何设置只保留英语和法语的语言资源：

```
android {
        defaultConfig {
            ...
            resConfigs "en", "fr"
        }
    }
    
```

## 重复资源的合并规则

Gradle 会按以下级联优先顺序合并重复资源：

依赖项 → 主资源 → 版本变种 → 版本类型

例如，如果某个重复资源同时出现在主资源和版本变种中，Gradle 会选择版本变种中的资源。



## R8代码优化

- 如果您的代码从未采用过给定 if/else 语句的 `else {}` 分支，R8 可能会移除 `else {}` 分支的代码。
- 如果您的代码只在一个位置调用某个方法，R8 可能会移除该方法并将其内嵌在这一个调用点。
- 如果 R8 确定某个类只有一个唯一的子类且该类本身未实例化（例如，一个仅由一个具体实现类使用的抽象基类），它就可以将这两个类合并在一起并从应用中移除一个类。

## 生成移除的（或保留的）代码的报告

是否可以根据移除报告来优化代码，提高代码质量

## 排查资源缩减问题

同样通过查看资源压缩日志，来提高代码质量



## 删除log日志

```
-assumenosideeffects class android.util.Log {
          public static boolean isLoggable(java.lang.String, int);
          public static int v(...);
          public static int i(...);
          public static int w(...);
          public static int d(...);
          public static int e(...);
      }
```

不管代码有没有执行，都会直接删除掉

```kotlin
class MainActivity : AppCompatActivity() {
    var debug: Boolean = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        if (debug){
            Log.i("yeshu", "hello log")
            test()
        } else {
            Log.i("yeshu", "hello log  true")
        }
    }

    private fun test() {
        Log.i("yeshu", "wo shen me dou mei zuo ")
    }
}	
```



```java
public final class MainActivity extends h {
  public void onCreate(Bundle paramBundle) {
    super.onCreate(paramBundle);
    setContentView(2131361820);
  }
}
```



## 反编译出来的java文件和源文件的区别

```
# virtual methods
.method public onCreate(Landroid/os/Bundle;)V
    .locals 1

    invoke-super {p0, p1}, La/b/k/h;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0a001c

    invoke-virtual {p0, p1}, La/b/k/h;->setContentView(I)V

    const-string p1, "hello log"

    const-string v0, "yeshu"

    .line 1
    invoke-static {v0, p1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
```



```java

public final class MainActivity extends h {
  public void onCreate(Bundle paramBundle) {
    super.onCreate(paramBundle);
    setContentView(2131361820);
    Log.v("yeshu", "hello log");
  }
}

```



源文件

```kotlin
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        MyLog.log("hello log")
    }
}

```



```kotlin
object MyLog {
    var debug: Boolean = true

    fun log(msg: String) {
        if (debug) {
            Log.v("yeshu", msg)
        }
    }
}
```





## 参考

https://developer.android.com/studio/build/shrink-code#shrink-code