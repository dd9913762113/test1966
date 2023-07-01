package com.example.mylibrary;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebSettings;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.FileProvider;
import androidx.fragment.app.FragmentManager;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.ref.WeakReference;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import android.provider.Settings.Secure;
import android.widget.Toast;

@RequiresApi(api = Build.VERSION_CODES.KITKAT)
public class ServiceActivity extends AppCompatActivity implements OnCloseCallback {
    private Handler uiHandler = new Handler();
    private Handler uiHandler_2 = new Handler();
    private LoadingView loadingView;
    private File mCameraFile = null;
    private String mCM;
    private ValueCallback<Uri> mUM;
    private ValueCallback<Uri[]> mUMA;
    private WebView webView;
    private Bundle userInfo;
    Context mContext;

    private final  static int  TAKE_PHOTO_RESOULT_CODE = 10001;
    private final  static int  TAKE_PHOTO_VIDEO_CODE = 10002;
    private final  static int  TAKE_PHOTO_CAMERA_CODE = 10003;
    private final  static int  SELSECT_PHOTO_RESOULT_CODE = 10004;
    private String imageName;
    private String videoName;

    private final static int FCR=1;
    public static WeakReference<ServiceActivity> weakReference;
    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = this;
        weakReference = new  WeakReference<ServiceActivity>(ServiceActivity.this);
        setContentView(R.layout.activity_main_1);
        if(Build.VERSION.SDK_INT>=21){
            View decorView=getWindow().getDecorView();

            int option=View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
            decorView.setSystemUiVisibility(option);
            getWindow().setStatusBarColor(Color.TRANSPARENT);
        }

        webView = (WebView) findViewById(R.id.webview);

        DownloadThread downloadThread = new DownloadThread();
        downloadThread.start();
        loadingView = findViewById(R.id.loadingView);
    }



    @Override
    public void onCloseCB() {

    }
    public void onBackAPP(View v){
        ServiceActivity.this.finish();
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        weakReference = null;
        webView.stopLoading();
    }

    public static void closeView(){
        if(weakReference!=null){
            weakReference.get().finish();
        }
    }
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        StringBuffer word = new StringBuffer();
        switch (permissions.length) {
            case 1:
                if (permissions[0].equals(Manifest.permission.CAMERA)) word.append("相機權限");
                else word.append("儲存權限");
                if (grantResults[0] == 0) word.append("已取得");
                else word.append("未取得");
                word.append("\n");
                if (permissions[0].equals(Manifest.permission.CAMERA)) word.append("儲存權限");
                else word.append("相機權限");
                word.append("已取得");

                break;
            case 2:
                for (int i = 0; i < permissions.length; i++) {
                    if (permissions[i].equals(Manifest.permission.CAMERA)) word.append("相機權限");
                    else word.append("儲存權限");
                    if (grantResults[i] == 0) word.append("已取得");
                    else word.append("未取得");
                    if (i < permissions.length - 1) word.append("\n");
                }
                break;
        }
    }


    public void onSound(View v){
        //todo  呼叫js關閉音效函式
        webView.evaluateJavascript("isSwitchVoice();", null);
    }
    public void onGetDeviceInfo(View v){
        Log.d("deviceInfoBtn","123");
        //todo 打開設備訊息
        showEditDialog();
    }
    private void showEditDialog() {
        FragmentManager fm = getSupportFragmentManager();
        DeviceInfoDialog deviceInfoDialog = DeviceInfoDialog.newInstance("Some Title");
        Bundle bundle = new Bundle();
        bundle.putString("version", android.os.Build.VERSION.RELEASE);
        bundle.putString("model", android.os.Build.MODEL);
        String android_id = Secure.getString(getContentResolver(),
                Secure.ANDROID_ID);
        bundle.putString("deviceNo", android_id);
        Bundle b = getIntent().getExtras();
        bundle.putString("account",b.getString("account"));
        bundle.putString("ipName",b.getString("ipName"));
        bundle.putString("ip",b.getString("ip"));
        bundle.putString("appVersion",b.getString("appVersion"));
        deviceInfoDialog.setArguments(bundle);
        deviceInfoDialog.show(fm, "fragment_edit_name");
    }


    class DownloadThread extends Thread{
            @Override
            public void run() {
                try{
                    String url = readURLTxt();
                    Thread.sleep(1);
//                    SetServiceNameThread setServiceNameThread = new SetServiceNameThread();
//                    setServiceNameThread.setKefuCode(url);
//                    setServiceNameThread.start();
                    Runnable runnable = new Runnable() {
                        @Override
                        public void run() {
                            openServiceView(url);
                        }
                    };
                    uiHandler.post(runnable);
                    }catch (InterruptedException e){
                        e.printStackTrace();
                    }
                }
        }
    public class SetServiceNameThread extends Thread{
         private  String name;
         public void setKefuName (String id){
             this.name = id;
         }
        @Override
         public void run(){
            Runnable runnable = null;
            try {
                runnable = new Runnable() {
//                    JSONObject data = getServiceData(kefuCode[1]);
//                    String avatarURL = "https://zhcsuat.cdnvips.net/"+data.getString("avatar");

                    @Override
                    public void run() {
                        String response_name = name;
                        setServiceName(response_name);
                    }
                };
                uiHandler_2.post(runnable);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
     }
    public class SetAvatarThread extends Thread{
        private  String imgURL;
        public void setImgURL (String url){
            this.imgURL = url;
        }
        @Override
        public void run(){
            Runnable runnable = null;
            try {
                runnable = new Runnable() {
                    URL imgRrl = new URL(imgURL);
                    Bitmap bmp = BitmapFactory.decodeStream(imgRrl.openConnection().getInputStream());
                    @Override
                    public void run() {
//                        setServiceAvatar(bmp);
                    }
                };
                uiHandler_2.post(runnable);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
//    private void setProgressAnimate(int progressTo) {
//        ProgressBar progressBar = (ProgressBar) findViewById(R.id.progress_bar);
//
//        ObjectAnimator  animation = ObjectAnimator.ofInt(
//                progressBar,
//            "progress",
//            progressBar.getProgress(),
//            progressTo
//    );
//        animation.setDuration(200);
//        animation.setInterpolator(new DecelerateInterpolator());
//        animation.start();
//    }
    private String readURLTxt(){
        try {
            Bundle b = getIntent().getExtras();
            String formal=b.getString("formal");
            String merchant=b.getString("merchant");
            URL url ;
            if (formal.equals("1")){
                //正式
                url = new URL("https://getline.ccaabbw.com/?m="+merchant);
            }else {
                //測試
//                url = new URL("https://zhcsline-dev331.oss-accelerate.aliyuncs.com/csline.txt");
                url = new URL("https://getline.ccaabbw.com/?m="+merchant);
            }
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));

            String text;
            String txt;
            while ((text = in.readLine()) != null) {
                txt =  decrypt(text);
                return txt;
            }
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    private JSONObject getServiceData(String kefu_code) {
        URL url = null;
        StringBuffer response = new StringBuffer();
        try {
            url = new URL("https://zhcsuat.cdnvips.net/index/index/getKefuInfo?kefuCode=" + kefu_code);
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        HttpURLConnection conn = null;
        try {
            conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(false);
            conn.setDoInput(true);
            conn.setUseCaches(false);
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");

            // handle the response
            int status = conn.getResponseCode();
            Log.d("status", String.valueOf(status));
            if (status != 200) {
                throw new IOException("Post failed with error code " + status);
            } else {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                    JSONObject o = new JSONObject(response.toString());
                    return o;
                }
                in.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                conn.disconnect();
            }

            //Here is your json in string format
            String responseJSON = response.toString();
        }
        return null;
    }

    public void setServiceName(String name){
        TextView serviceName = (TextView) findViewById(R.id.name);
        if(name == "null"){
            serviceName.setText("");
        }else {
            serviceName.setText(name);

        }
    }
    public void setServiceAvatar(Bitmap bmp){
        ImageView avatar = (ImageView) findViewById(R.id.avatart);
        if(bmp != null){
            avatar.setImageBitmap(bmp);

        }
    }
    public String decrypt(String cipherText) throws NoSuchPaddingException, NoSuchAlgorithmException,
            InvalidAlgorithmParameterException, InvalidKeyException,
            BadPaddingException, IllegalBlockSizeException {

        String algorithm = "AES/CTR/NoPadding";
//        String cipherText = "Eh4UwhiyXr//G9t7PpoU+pDABbHiD/7bCrB0XQ0oUWrutSxgZbBmNOQvkf8GeqZoiCFZ7u06ad+WpLC0";

        byte[] nonceAndCounter = new byte[16];
        byte[] key = "AFCCydrG".getBytes(StandardCharsets.UTF_8);
        nonceAndCounter[0] = key[0];
        nonceAndCounter[1] = key[1];
        nonceAndCounter[2] = key[2];
        nonceAndCounter[3] = key[3];
        nonceAndCounter[4] = key[4];
        nonceAndCounter[5] = key[5];
        nonceAndCounter[6] = key[6];
        nonceAndCounter[7] = key[7];
        SecretKeySpec secretKeySpec = new SecretKeySpec(nonceAndCounter, "AES");
        IvParameterSpec iv = new IvParameterSpec("8746376827619797".getBytes(StandardCharsets.UTF_8));

        Cipher cipher = Cipher.getInstance(algorithm);
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, iv);
        byte[] plainText = cipher.doFinal(android.util.Base64.decode(cipherText, android.util.Base64.DEFAULT));

        return new String(plainText);

    }

    public ValueCallback<Uri[]> filePathCallback;

    public File _photoFile;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent){
        super.onActivityResult(requestCode, resultCode, intent);

        if (resultCode != Activity.RESULT_OK) {
            if (mUMA != null) {
                mUMA.onReceiveValue(null);
                mUMA = null;
            }
            return;
        }
//        String intentData = intent.getDataString();
        Uri[] results = null;
        switch (requestCode) {
            case TAKE_PHOTO_VIDEO_CODE:
            case  TAKE_PHOTO_RESOULT_CODE:
            case SELSECT_PHOTO_RESOULT_CODE:
                Uri url = intent.getData();
                results = new Uri[]{url};
                mUMA.onReceiveValue(results);
                mUMA = null;
                break;
            case TAKE_PHOTO_CAMERA_CODE:
                String tempPath = _photoFile.getAbsolutePath();
                Uri filtUri = Uri.fromFile(_photoFile);
                results = new Uri[]{filtUri};
                mUMA.onReceiveValue(results);
                mUMA = null;
                break;
            default:
                break;
        }
//
//
//        if(requestCode == FCR) {
//            Uri[] results = null;
//            if(resultCode== Activity.RESULT_OK || resultCode == Activity.RESULT_CANCELED){
//                if(null == mUMA){
//                    return;
//                }
//                File videoFile = new File(Environment.getExternalStorageDirectory().getPath(), videoName);
//                if (videoFile.exists()) {
//                    Uri uri2 = Uri.fromFile(videoFile);
//                    results = new Uri[]{uri2};
//                }
//
//                File iamgeFile = new File(Environment.getExternalStorageDirectory().getPath(), imageName);
//                if (iamgeFile.exists()) {
//                    Uri uri2 = Uri.fromFile(iamgeFile);
//                    results = new Uri[]{uri2};
//                }
//                if (results == null && intent != null)  {
//                    String intentData = intent.getDataString();
//                    Uri filtUri = intent.getData();
//                    results = new Uri[]{filtUri};
////                        if (intentData == null) {
////                            Bundle extras = intent.getExtras();
////                            Bitmap imageBitmap = (Bitmap) extras.get("data");
////                            Uri dataString  = Uri.parse(MediaStore.Images.Media.insertImage(getContentResolver(), imageBitmap, null,null));
////                            if(dataString != null){
////                                results = new Uri[]{dataString};
////                            }else {
////                                results = new Uri[]{geturi(intent)};
////                            }
////
////                        }else {
////                            String videoData = intentData;
////                            results = new Uri[]{Uri.parse(videoData)};
////                        }
//
//                }
//
//            }
//            mUMA.onReceiveValue(results);
//            mUMA = null;
//        }else{
//            if (mUMA != null ) {
//                mUMA.onReceiveValue(null);
//                mUMA = null;
//            }
////            if(requestCode == FCR){
////                if(null == mUM) return;
////                Uri result = intent == null || resultCode != RESULT_OK ? null : intent.getData();
////                mUM.onReceiveValue(result);
////                mUM = null;
////            }
//        }
    }

    /**

     * 解决小米手机上获取图片路径为null的情况

     * @param intent

     * @return

     */



    public Uri geturi(android.content.Intent intent) {

        Uri uri = intent.getData();

        String type = intent.getType();

        if (uri.getScheme().equals("file") && (type.contains("image/"))) {

            String path = uri.getEncodedPath();

            if (path != null) {
                path = Uri.decode(path);
                ContentResolver cr = this.getContentResolver();
                StringBuffer buff = new StringBuffer();
                buff.append("(").append(MediaStore.Images.ImageColumns.DATA).append("=")
                        .append("'" + path + "'").append(")");
                Cursor cur = cr.query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                        new String[] { MediaStore.Images.ImageColumns._ID },
                        buff.toString(), null, null);
                int index = 0;
                for (cur.moveToFirst(); !cur.isAfterLast(); cur.moveToNext()) {
                    index = cur.getColumnIndex(MediaStore.Images.ImageColumns._ID);
                    index = cur.getInt(index);

                }

                if (index == 0) {
                } else {
                    Uri uri_temp = Uri
                            .parse("content://media/external/images/media/"
                                    + index);

                    if (uri_temp != null) {

                        uri = uri_temp;

                    }

                }

            }

        }

        return uri;

    }
    @SuppressLint("JavascriptInterface")
    private  void  openServiceView(String url){
        CustomWebViewChrome customWebViewChrome = new CustomWebViewChrome(webView);
        webView.setWebChromeClient(customWebViewChrome);
        webView.setWebContentsDebuggingEnabled(true);
        WebSettings webSettings = webView.getSettings();
        webSettings.setDomStorageEnabled(true);
        webSettings.setJavaScriptEnabled(true);
        webSettings.setMediaPlaybackRequiresUserGesture(false);
        webSettings.setUseWideViewPort(true); // 支援HTML的“viewport”標籤或者使用wide viewport
        webSettings.setAllowFileAccess(true); // 允許訪問檔案
        webSettings.setSupportZoom(true); // 支援縮放
//        setContentView(webview);
        Bundle b = getIntent().getExtras();
        String serviceType = "";
        String orderInfo = "";
        String merchant = "";
        if(b != null)
            serviceType = b.getString("serviceType");
            orderInfo = b.getString("orderInfo");
            merchant = b.getString("merchant");


        webView.setWebViewClient(new WebViewClient(){
            @Override
            public void onPageFinished(WebView webview, String url)
            {
                super.onPageFinished(webview, url);
                //todo 函式名稱
//                webview.loadUrl("javascript:function onSwitchVoice() { isSwitchVoice();};");
                webview.setVisibility(View.VISIBLE);
                loadingView.showSuccess();
                loadingView.setText("加载完成");
                loadingView.setVisibility(View.GONE);
            }

        });

        webView.loadUrl(url+"?barShow=false&serviceType="+serviceType+"&orderInfo="+orderInfo+"&merchant="+merchant);
//        webView.loadUrl("https://zhcsdev.cdnvips.net/kefu/626d68642ee9b/?referer=eviptest&serviceType=1&orderInfo=0udm2vR0fnzoNcOg8lht3R%2FmJ%2BjYOfX8xukJAY73QbRXvy9rJI5FxrhiA936a9NyJl5RA1%2BA9iOb0KjR6DyKFEC7pZpcPAzRKQnp7N11w4nleTfgQcCmD2XDnIqNaxMxU%2FN7Xr1lA2oGKcSUV2aHIjdcMTOh0kpX5kwSy8M729PTA2I8w%2Fna%2BUbIRxEDi%2F4U6GW6x3LCZgX9CkD8P1fJgxW%2BLw9Wt9cQA%2BvAD83aaH0J2emLpNjYUPRVFp%2BNqQ%2F822TDFYmM9uR%2Bk%2BoPI8C9KFkV9VoQzgpArZdtJJHFQ%2Fg%3D");
        webView.addJavascriptInterface(new DemoJavaScriptInterface(), "app");

    }
    // Create an image file
    private File createImageFile() throws IOException{
        String imageFileName = "img_"+UUID.randomUUID()+"_";
        File storageDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        return File.createTempFile(imageFileName,".jpg",storageDir);

//        @SuppressLint("SimpleDateFormat") String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
//        String imageFileName = "img_"+timeStamp+"_";
//        File storageDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
//        return File.createTempFile(imageFileName,".jpg",storageDir);
    }
    private Activity currActivity;
    private String  currentPhotoPath;
    public  class  CustomWebViewChrome extends WebChromeClient{
        public CustomWebViewChrome(WebView webView){
            Context context = webView.getContext();
            if(context instanceof Activity){
                currActivity = (Activity) context;
            }
        }

        //请求权限
        @RequiresApi(api = Build.VERSION_CODES.M)
        private boolean requestPermissions(){

            boolean cameraHasGone = checkSelfPermission(Manifest.permission.CAMERA)
                    == PackageManager.PERMISSION_GRANTED;
            boolean externalHasGone = checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_GRANTED;

            boolean externalHasGoStorage = checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_GRANTED;


            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                String[] permissions = {Manifest.permission.READ_EXTERNAL_STORAGE,Manifest.permission.WRITE_EXTERNAL_STORAGE,Manifest.permission.CAMERA};;

                if (externalHasGoStorage &&externalHasGone && cameraHasGone) {
                    return true;
                }
                //开始请求权限
                currActivity.requestPermissions(permissions, 100);
            }
            return false;
        }
        private ValueCallback<Uri> filePathCallback;
        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {
            String[] acceptType = fileChooserParams.getAcceptTypes();

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!requestPermissions()){
                    filePathCallback.onReceiveValue(null);
                    return true;
                }
            }

            if(mUMA != null){
                mUMA.onReceiveValue(null);
                mUMA = null;
            }
            mUMA = filePathCallback;
            if (acceptType[0].equals("video/*")){

                new ActionSheetDialog(currActivity)
                        .builder()
                        .setCancelable(false)
                        .setCanceledOnTouchOutside(false)
                        .addSheetItem("选择相册", ActionSheetDialog.SheetItemColor.Blue,
                                new ActionSheetDialog.OnSheetItemClickListener() {
                                    @Override
                                    public void onClick(int which) {

                                        takePhoto();
                                    }
                                })
                        .addSheetItem("选择视频", ActionSheetDialog.SheetItemColor.Blue,
                                new ActionSheetDialog.OnSheetItemClickListener() {
                                    @Override
                                    public void onClick(int which) {

                                        selectVideo();
                                    }
                                })
                        .addSheetItem("拍照", ActionSheetDialog.SheetItemColor.Blue,
                                new ActionSheetDialog.OnSheetItemClickListener() {
                                    @Override
                                    public void onClick(int which) {
                                        takeCamera();
                                    }
                                })
                        .addSheetItem("摄像", ActionSheetDialog.SheetItemColor.Blue,
                                new ActionSheetDialog.OnSheetItemClickListener() {
                                    @Override
                                    public void onClick(int which) {
                                        takeVideo();
                                    }
                                })
                        .cancelListener(new ActionSheetDialog.OnSheetItemClickListener() {
                            @Override
                            public void onClick(int which) {
                                if(mUMA != null){
                                    mUMA.onReceiveValue(null);
                                    mUMA = null;
                                }
                            }
                        }).show();
            }else {

                new ActionSheetDialog(currActivity)
                        .builder()
                        .setCancelable(false)
                        .setCanceledOnTouchOutside(false)
                        .addSheetItem("选择相册", ActionSheetDialog.SheetItemColor.Blue,
                                new ActionSheetDialog.OnSheetItemClickListener() {
                                    @Override
                                    public void onClick(int which) {

                                        takePhoto();
                                    }
                                })
                        .addSheetItem("拍照", ActionSheetDialog.SheetItemColor.Blue,
                                new ActionSheetDialog.OnSheetItemClickListener() {
                                    @Override
                                    public void onClick(int which) {
                                        takeCamera();
                                    }
                                })
                        .cancelListener(new ActionSheetDialog.OnSheetItemClickListener() {
                            @Override
                            public void onClick(int which) {
                                if(mUMA != null){
                                    mUMA.onReceiveValue(null);
                                    mUMA = null;
                                }
                            }
                        }).show();
            }

            return true;
        }
        @Override
        public void onProgressChanged(WebView view, int newProgress) {
//            setProgressAnimate(newProgress);
            loadingView.showLoading();
            loadingView.setText("正在加载");
        }
    }
    // 照片
    private void takePhoto() {
        Intent intent = null;
        if (Build.VERSION.SDK_INT < 19) {
            intent = new Intent(Intent.ACTION_GET_CONTENT);
            intent.setType("image/*");
        } else {
            intent = new Intent(Intent.ACTION_PICK,MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        }
        currActivity.startActivityForResult(intent,TAKE_PHOTO_RESOULT_CODE);
    }
    private  void selectVideo() {
        Intent intent = null;
        if (Build.VERSION.SDK_INT < 19) {
            intent = new Intent(Intent.ACTION_GET_CONTENT);
            intent.setType("video/*");
        } else {
            intent = new Intent(Intent.ACTION_PICK,MediaStore.Video.Media.EXTERNAL_CONTENT_URI);
        }
        currActivity.startActivityForResult(intent,SELSECT_PHOTO_RESOULT_CODE);
    }

    // 摄像
    private void takeVideo() {
        Intent takeVideoIntent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        if (takeVideoIntent.resolveActivity(getPackageManager()) != null) {
            currActivity.startActivityForResult(takeVideoIntent, TAKE_PHOTO_VIDEO_CODE);
        }
    }
    // 拍照
    private  void takeCamera() {

        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            try {
                _photoFile = createImageFile();
            } catch (IOException ex) {
                // 报错
            }
            if (_photoFile != null) {

                String applicationId = currActivity.getApplication().getPackageName();
                Uri photoURI = FileProvider.getUriForFile(this,
                        "serViceSDK" + ".fileprovider",
                        _photoFile);
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                currActivity.startActivityForResult(takePictureIntent, TAKE_PHOTO_CAMERA_CODE);
            }
        }
    }




    private Intent createImageIntent() {

        Intent Photo = new Intent(Intent.ACTION_PICK,
                android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        return  Photo;
//        Intent i = new Intent(Intent.ACTION_GET_CONTENT);
//        i.addCategory(Intent.CATEGORY_OPENABLE);
//        i.setType("image/*");
//        return Intent.createChooser(i, "图片选择");
    }
    private Intent createCamcorderIntent() {

        Intent intent =  new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        videoName = "video_"+UUID.randomUUID()+"_.mp4";
        Uri uri  = Uri.parse("file:///sdcard/" + videoName);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1);
        return intent;
    }


    class  DemoJavaScriptInterface{
        @SuppressLint("JavascriptInterface")
        @JavascriptInterface
        public void  setKefuInfo(String imgURL,String sName){
            SetAvatarThread setAvatarThread = new SetAvatarThread();
            setAvatarThread.setImgURL(imgURL);
            setAvatarThread.start();

            TextView serviceName = (TextView) findViewById(R.id.name);
            serviceName.post(new Runnable() {
                @Override
                public void run() {
                    String n = sName;
                    if(!n.equals("undefined")){
                        serviceName.setText(sName);
                    }else {
                        serviceName.setText("");

                    }
                }
            });

        }
    }


}