---
title: Android拍照后获取图片
permalink: androidpai-zhao-hou-huo-qu-tu-pian
id: 78
updated: '2016-05-12 07:53:45'
date: 2016-05-12 07:44:46
tags:
---

   Android调用相机拍照时，如果设置了保存路径则不会直接返回bitmap,反之会返回一个调整过角度的压缩的图片。
   
```java
    // First handle the no crop case -- just return the value.  If the
            // caller specifies a "save uri" then write the data to it's
            // stream. Otherwise, pass back a scaled down version of the bitmap
            // directly in the extras.
            if (mSaveUri != null) {
                OutputStream outputStream = null;
                try {
                    outputStream = mContentResolver.openOutputStream(mSaveUri);
                    outputStream.write(data);
                    outputStream.close();
                    setResult(RESULT_OK);
                    finish();
                } catch (IOException ex) {
                    // ignore exception
                } finally {
                    Util.closeSilently(outputStream);
                }
            } else {
                Bitmap bitmap = createCaptureBitmap(data);
                setResult(RESULT_OK,
                        new Intent("inline-data").putExtra("data", bitmap));
                finish();
            }
```
 
   
```java   
    public static int getExifOrientation(String filepath) {
	        int degree = 0;
	        ExifInterface exif = null;
	        try {
	            exif = new ExifInterface(filepath);
	        } catch (IOException ex) {
	            Log.e(TAG, "cannot read exif", ex);
	        }
	        if (exif != null) {
	            int orientation = exif.getAttributeInt(
	                ExifInterface.TAG_ORIENTATION, -1);
	            if (orientation != -1) {
	                // We only recognize a subset of orientation tag values.
	                switch(orientation) {
	                    case ExifInterface.ORIENTATION_ROTATE_90:
	                        degree = 90;
	                        break;
	                    case ExifInterface.ORIENTATION_ROTATE_180:
	                        degree = 180;
	                        break;
	                    case ExifInterface.ORIENTATION_ROTATE_270:
	                        degree = 270;
	                        break;
	                }


	            }
	        }
	        return degree;
	    }


    private Bitmap createCaptureBitmap(byte[] data) {
	        // This is really stupid...we just want to read the orientation in
	        // the jpeg header.
	        String filepath = ImageManager.getTempJpegPath();
	        int degree = 0;
	        if (saveDataToFile(filepath, data)) {
	            degree = ImageManager.getExifOrientation(filepath);
	            new File(filepath).delete();
	        }
	
	        // Limit to 50k pixels so we can return it in the intent.
	        Bitmap bitmap = Util.makeBitmap(data, 50*1024);
	        bitmap = Util.rotate(bitmap, degree);
	        return bitmap;
	    }


    public boolean saveDataToFile(String filePath, byte[] data) {
	        FileOutputStream f = null;
	        try {
	            f = new FileOutputStream(filePath);
	            f.write(data);
	        } catch (IOException e) {
	            return false;
	        } finally {
	            MenuHelper.closeSilently(f);
	        }
	        return true;
	    }
```

// 这里面很多好用的代码,但是没搞懂这是哪个版本的代码？发现LG手机拍照后返回的图片没有调整过角度
https://android.googlesource.com/platform/packages/apps/Camera/+/b02ebbea2d3d98a3ab2c15cb152387b9d201dd18/src/com/android/camera
