package com.example.myapplication;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.example.mylibrary.CustomerServiceUtils;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Handler handler = new Handler();
//        handler.postDelayed(new Runnable() {
//            @RequiresApi(api = Build.VERSION_CODES.KITKAT)
//            @Override
//            public void run() {
//                CustomerServiceUtils.onCloseSdk();
//            }
//        }, 5000);
        Button btnOne = (Button) findViewById(R.id.serBtn);
        btnOne.setOnClickListener(new View.OnClickListener() {
            @RequiresApi(api = Build.VERSION_CODES.KITKAT)
            @Override
            public void onClick(View v) {
//                Intent intent = new Intent(MainActivity.this, com.example.mylibrary.MainActivity.class);
//                Bundle b = new Bundle();
//                b.putString("key", "cdn-test-kevin-1.cdnvips.net"); //Your id
//                intent.putExtras(b);
//                startActivity(intent);

                CustomerServiceUtils.startCustomerService(
                        "devjlb",
                        "account",
                        "平台名稱",
                        "192.272.118.1",
                        "v.1.0.1",
                        "0",
                        "",
                        "0",
                        MainActivity.this);
//
            }
        });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode ==  CustomerServiceUtils.DBJ_CUSTOMER_SERVICE_REQUEST_CODE) {
            Log.d("onActivityResult:", "客服界面退出");
        }
    }
}