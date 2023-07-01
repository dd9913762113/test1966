package com.example.mylibrary;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.RequiresApi;

import java.io.Serializable;

public class CustomerServiceUtils  {

//    CustomerService
    final public static int DBJ_CUSTOMER_SERVICE_REQUEST_CODE = 10001;

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    public static void startCustomerService(String merchant, String account, String ipName, String ip, String appVersion, String serviceType, String orderInfo, String formal, Activity context) {
        Intent intent = new Intent(context, ServiceActivity.class);
        Bundle b = new Bundle();
        b.putString("merchant", merchant); //商戶號ex.BP
        b.putString("account",account);//玩家帳號
        b.putString("ipName",ipName);//平台名稱ex.E體育
        b.putString("ip",ip);//登入ip位置
        b.putString("appVersion",appVersion);//APP版本
        b.putString("serviceType",serviceType);//一般客服帶0財務客服帶1
        b.putString("orderInfo",orderInfo);//獲取訂單資訊加密的字串
        b.putString("formal",formal);//正式版=1測試版=0 對應發布版本
        intent.putExtras(b);
        context.startActivityForResult(intent,DBJ_CUSTOMER_SERVICE_REQUEST_CODE,b);
    }



    public interface CloseCBInterFace extends Serializable {
        public void onClose();
    }
    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    public static void onCloseSdk(CloseCBInterFace cb){
        cb.onClose();
        ServiceActivity.closeView();
    }

}
