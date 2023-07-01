package com.example.mylibrary;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;

import org.w3c.dom.Text;


public  class DeviceInfoDialog extends DialogFragment {
    private TextView _phoneModel , _deviceNo , _phoneSystem,_account,_ip,_ipName,_appVersion;
    private ClipboardManager cm;
    private ClipData clipData;
    public DeviceInfoDialog() {
    }
        //在該實例中傳入顯示的標題(title)
    public static DeviceInfoDialog newInstance(String  title) {
        DeviceInfoDialog frag = new DeviceInfoDialog();
        Bundle args = new Bundle();
        args.putString("title", title);
        frag.setArguments(args);
        return frag;
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.device_info_view, container, false);
        // Set transparent background and no title
        if (getDialog() != null && getDialog().getWindow() != null) {
            getDialog().getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            getDialog().getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        }
        ((Button) view.findViewById(R.id.closeBtn)).setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // When button is clicked, call up to owning activity.
                getDialog().dismiss();
            }
        });

        _phoneModel = ((TextView) view.findViewById(R.id.phoneModel));
        _deviceNo = ((TextView) view.findViewById(R.id.deviceNo));
        _phoneSystem = ((TextView) view.findViewById(R.id.phoneSystem));
        _account = ((TextView) view.findViewById(R.id.account));
        _ip = ((TextView) view.findViewById(R.id.ip));
        _ipName = ((TextView) view.findViewById(R.id.ipName));
        _appVersion = ((TextView) view.findViewById(R.id.appVersion));
        Bundle bundle = getArguments();
        if (bundle != null) {
            _phoneModel.setText(bundle.getString("model"));
            _deviceNo.setText(bundle.getString("deviceNo"));
            _phoneSystem.setText("Android "+bundle.getString("version"));
            _account.setText(bundle.getString("account"));
            _ip.setText(bundle.getString("ip"));
            _ipName.setText(bundle.getString("ipName"));
            _appVersion.setText(bundle.getString("appVersion"));
            String clipStr = "会员帐号:"+bundle.getString("account")+"\n"+
                    "手机型号:"+bundle.getString("model")+"\n"+
                    "设备号:"+bundle.getString("deviceNo")+"\n"+
                    "登入端口:"+bundle.getString("ipName")+"\n"+
                    "登陆IP:"+bundle.getString("ip")+"\n" +
                    "手机系统: Android "+bundle.getString("version")+"\n"+
                    "APP版本:"+bundle.getString("appVersion");
            clipData = ClipData.newPlainText(null,clipStr);
        }
        ((Button) view.findViewById(R.id.copyBtn)).setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                cm = (ClipboardManager) getContext().getSystemService(Context.CLIPBOARD_SERVICE);
                // 將文字內容放到系統剪貼簿裡。
                cm.setPrimaryClip(clipData);

                Toast.makeText(getContext(), "复制成功!", Toast.LENGTH_LONG).show();

            }
        });
        return view;
    }
    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        // Get field from view
//        mEditText = (EditText) view.findViewById(R.id.txt_your_name);
        // Fetch arguments from bundle and set title
        String title = getArguments().getString("title", "Enter Name");
        getDialog().setTitle(title);
        // Show soft keyboard automatically and request focus to field
//        mEditText.requestFocus();
        getDialog().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE);

    }

    public void onCopy(){
        //todo 複製傳送

    }
    public void setDeviceInfo(String[] data){
        _phoneModel.setText("123123");
    }
}
