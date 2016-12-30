---
id: 340
title: '[转]android蓝牙隐秘API'
date: 2011-03-10T09:39:56+00:00
author: tanglei
layout: post
guid: http://www.tanglei.name/?p=340
duoshuo_thread_id:
  - 1351844048792453151
enable_highlight:
  - '<link rel="stylesheet" href="../wp-content/blogresources/highlightconfig/highlight.default.min.css"><script src="../wp-content/blogresources/highlightconfig/jquery-2.1.4.min.js"></script><script src="../wp-content/blogresources/highlightconfig/enable_highlight.js"></script>'
categories:
  - 网络文摘
tags:
  - Android
---
今天看了篇文章，思想值得学习呀。要学会用反射……

本文来自<http://blog.csdn.net/hellogv/> ，引用必须注明出处！

上次讲解[Android的蓝牙基本用法](http://blog.csdn.net/hellogv/archive/2010/11/26/6036849.aspx)，这次讲得深入些，探讨下蓝牙方面的隐藏API。用过Android系统设置(Setting)的人都知道蓝牙搜索之后可以**建立配对**和**解除配对**，但是这两项功能的函数没有在SDK中给出，那么如何去使用这两项功能呢？本文利用JAVA的反射机制去调用这两项功能对应的函数：createBond和removeBond，具体的发掘和实现步骤如下：

1.使用Git工具下载platform/packages/apps/Settings.git，在Setting源码中查找关于**建立配对**和**解除配对**的API，知道这两个API的宿主(BluetoothDevice)；

2.使用反射机制对BluetoothDevice枚举其所有方法和常量，看看是否存在:

```java
static public void printAllInform(Class clsShow) {  
    try {  
        // 取得所有方法  
        Method[] hideMethod = clsShow.getMethods();  
        int i = 0;  
        for (; i < hideMethod.length; i++) {  
            Log.e("method name", hideMethod[i].getName());  
        }  
        // 取得所有常量  
        Field[] allFields = clsShow.getFields();  
        for (i = 0; i < allFields.length; i++) {  
            Log.e("Field name", allFields[i].getName());  
        }  
    } catch (SecurityException e) {  
        // throw new RuntimeException(e.getMessage());  
        e.printStackTrace();  
    } catch (IllegalArgumentException e) {  
        // throw new RuntimeException(e.getMessage());  
        e.printStackTrace();  
    } catch (Exception e) {  
        // TODO Auto-generated catch block  
        e.printStackTrace();  
    }  
} 
```

结果如下：

```java
11-29 09:19:12.012: method name(452): cancelBondProcess
11-29 09:19:12.020: method name(452): cancelPairingUserInput
11-29 09:19:12.020: method name(452): createBond
11-29 09:19:12.020: method name(452): createInsecureRfcommSocket
11-29 09:19:12.027: method name(452): createRfcommSocket
11-29 09:19:12.027: method name(452): createRfcommSocketToServiceRecord
11-29 09:19:12.027: method name(452): createScoSocket
11-29 09:19:12.027: method name(452): describeContents
11-29 09:19:12.035: method name(452): equals
11-29 09:19:12.035: method name(452): fetchUuidsWithSdp
11-29 09:19:12.035: method name(452): getAddress
11-29 09:19:12.035: method name(452): getBluetoothClass
11-29 09:19:12.043: method name(452): getBondState
11-29 09:19:12.043: method name(452): getName
11-29 09:19:12.043: method name(452): getServiceChannel
11-29 09:19:12.043: method name(452): getTrustState
11-29 09:19:12.043: method name(452): getUuids
11-29 09:19:12.043: method name(452): hashCode
11-29 09:19:12.043: method name(452): isBluetoothDock
11-29 09:19:12.043: method name(452): removeBond
11-29 09:19:12.043: method name(452): setPairingConfirmation
11-29 09:19:12.043: method name(452): setPasskey
11-29 09:19:12.043: method name(452): setPin
11-29 09:19:12.043: method name(452): setTrust
11-29 09:19:12.043: method name(452): toString
11-29 09:19:12.043: method name(452): writeToParcel
11-29 09:19:12.043: method name(452): convertPinToBytes
11-29 09:19:12.043: method name(452): getClass
11-29 09:19:12.043: method name(452): notify
11-29 09:19:12.043: method name(452): notifyAll
11-29 09:19:12.043: method name(452): wait
11-29 09:19:12.051: method name(452): wait
11-29 09:19:12.051: method name(452): wait
```

3.如果枚举发现API存在(SDK却隐藏)，则自己实现调用方法：

```java
	/**
	 * 与设备配对 参考源码：platform/packages/apps/Settings.git
	 * \Settings\src\com\android\settings\bluetooth\CachedBluetoothDevice.java
	 */
	static public boolean createBond(Class btClass,BluetoothDevice btDevice) throws Exception {
		Method createBondMethod = btClass.getMethod("createBond");
		Boolean returnValue = (Boolean) createBondMethod.invoke(btDevice);
		return returnValue.booleanValue();
	}

	/**
	 * 与设备解除配对 参考源码：platform/packages/apps/Settings.git
	 * \Settings\src\com\android\settings\bluetooth\CachedBluetoothDevice.java
	 */
	static public boolean removeBond(Class btClass,BluetoothDevice btDevice) throws Exception {
		Method removeBondMethod = btClass.getMethod("removeBond");
		Boolean returnValue = (Boolean) removeBondMethod.invoke(btDevice);
		return returnValue.booleanValue();
	}
```

PS:SDK之所以不给出隐藏的API肯定有其原因，也许是出于安全性或者是后续版本兼容性的考虑，因此不能保证隐藏API能在所有Android平台上很好地运行。。。

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
	android:orientation="vertical" android:layout_width="fill_parent"
	android:layout_height="fill_parent">
	<LinearLayout android:id="@+id/LinearLayout01"
		android:layout_height="wrap_content" android:layout_width="fill_parent">
		<Button android:layout_height="wrap_content" android:id="@+id/btnSearch"
			android:text="Search" android:layout_width="160dip"></Button>
		<Button android:layout_height="wrap_content"
			android:layout_width="160dip" android:text="Show" android:id="@+id/btnShow"></Button>
	</LinearLayout>
	<LinearLayout android:id="@+id/LinearLayout02"
		android:layout_width="wrap_content" android:layout_height="wrap_content"></LinearLayout>
	<ListView android:id="@+id/ListView01" android:layout_width="fill_parent"
		android:layout_height="fill_parent">
	</ListView>
</LinearLayout>
```

工具类ClsUtils.java源码如下：

```java
package com.testReflect;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import android.bluetooth.BluetoothDevice;
import android.util.Log;

public class ClsUtils {

	/**
	 * 与设备配对 参考源码：platform/packages/apps/Settings.git
	 * \Settings\src\com\android\settings\bluetooth\CachedBluetoothDevice.java
	 */
	static public boolean createBond(Class btClass,BluetoothDevice btDevice) throws Exception {
		Method createBondMethod = btClass.getMethod("createBond");
		Boolean returnValue = (Boolean) createBondMethod.invoke(btDevice);
		return returnValue.booleanValue();
	}

	/**
	 * 与设备解除配对 参考源码：platform/packages/apps/Settings.git
	 * \Settings\src\com\android\settings\bluetooth\CachedBluetoothDevice.java
	 */
	static public boolean removeBond(Class btClass,BluetoothDevice btDevice) throws Exception {
		Method removeBondMethod = btClass.getMethod("removeBond");
		Boolean returnValue = (Boolean) removeBondMethod.invoke(btDevice);
		return returnValue.booleanValue();
	}

	/**
	 * 
	 * @param clsShow
	 */
	static public void printAllInform(Class clsShow) {
		try {
			// 取得所有方法
			Method[] hideMethod = clsShow.getMethods();
			int i = 0;
			for (; i < hideMethod.length; i++) {
				Log.e("method name", hideMethod[i].getName());
			}
			// 取得所有常量
			Field[] allFields = clsShow.getFields();
			for (i = 0; i < allFields.length; i++) {
				Log.e("Field name", allFields[i].getName());
			}
		} catch (SecurityException e) {
			// throw new RuntimeException(e.getMessage());
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// throw new RuntimeException(e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
```

主程序testReflect.java的源码如下：

```java
package com.testReflect;

import java.util.ArrayList;
import java.util.List;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

public class testReflect extends Activity {
	Button btnSearch, btnShow;
	ListView lvBTDevices;
	ArrayAdapter<String> adtDevices;
	List<String> lstDevices = new ArrayList<String>();
	BluetoothDevice btDevice;
	BluetoothAdapter btAdapt;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		btnSearch = (Button) this.findViewById(R.id.btnSearch);
		btnSearch.setOnClickListener(new ClickEvent());
		btnShow = (Button) this.findViewById(R.id.btnShow);
		btnShow.setOnClickListener(new ClickEvent());

		lvBTDevices = (ListView) this.findViewById(R.id.ListView01);
		adtDevices = new ArrayAdapter<String>(testReflect.this,
				android.R.layout.simple_list_item_1, lstDevices);
		lvBTDevices.setAdapter(adtDevices);
		lvBTDevices.setOnItemClickListener(new ItemClickEvent());

		btAdapt = BluetoothAdapter.getDefaultAdapter();// 初始化本机蓝牙功能
		if (btAdapt.getState() == BluetoothAdapter.STATE_OFF)// 开蓝牙
			btAdapt.enable();

		// 注册Receiver来获取蓝牙设备相关的结果
		IntentFilter intent = new IntentFilter();
		intent.addAction(BluetoothDevice.ACTION_FOUND);
		intent.addAction(BluetoothDevice.ACTION_BOND_STATE_CHANGED);
		registerReceiver(searchDevices, intent);

	}

	
	private BroadcastReceiver searchDevices = new BroadcastReceiver() {
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			Bundle b = intent.getExtras();
			Object[] lstName = b.keySet().toArray();

			// 显示所有收到的消息及其细节
			for (int i = 0; i < lstName.length; i++) {
				String keyName = lstName[i].toString();
				Log.e(keyName, String.valueOf(b.get(keyName)));
			}
			// 搜索设备时，取得设备的MAC地址
			if (BluetoothDevice.ACTION_FOUND.equals(action)) {
				BluetoothDevice device = intent
						.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);

				if (device.getBondState() == BluetoothDevice.BOND_NONE) {
					String str = "未配对|" + device.getName() + "|" + device.getAddress();
					lstDevices.add(str); // 获取设备名称和mac地址
					adtDevices.notifyDataSetChanged();
				}
			}
		}
	};

	class ItemClickEvent implements AdapterView.OnItemClickListener {

		@Override
		public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
				long arg3) {
			btAdapt.cancelDiscovery();
			String str = lstDevices.get(arg2);
			String[] values = str.split("\\|");
			String address=values[2];

			btDevice = btAdapt.getRemoteDevice(address);
			try {
				if(values[0].equals("未配对"))
				{	
					Toast.makeText(testReflect.this, "由未配对转为已配对", 500).show();
					ClsUtils.createBond(btDevice.getClass(), btDevice);
				}
				else if(values[0].equals("已配对"))
				{
					Toast.makeText(testReflect.this, "由已配对转为未配对", 500).show();
					ClsUtils.removeBond(btDevice.getClass(), btDevice);
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}
	
	/**
	 * 按键处理
	 * @author GV
	 *
	 */
	class ClickEvent implements View.OnClickListener {

		@Override
		public void onClick(View v) {
			if (v == btnSearch) {//搜索附近的蓝牙设备
				lstDevices.clear();
				
				Object[] lstDevice = btAdapt.getBondedDevices().toArray();
				for (int i = 0; i < lstDevice.length; i++) {
					BluetoothDevice device=(BluetoothDevice)lstDevice[i];
					String str = "已配对|" + device.getName() + "|" + device.getAddress();
					lstDevices.add(str); // 获取设备名称和mac地址
					adtDevices.notifyDataSetChanged();
				}
				// 开始搜索
				setTitle("本机蓝牙地址：" + btAdapt.getAddress());
				btAdapt.startDiscovery();
			}
			else if(v==btnShow){//显示BluetoothDevice的所有方法和常量，包括隐藏API
				ClsUtils.printAllInform(btDevice.getClass());
			}

		}

	}


}
```
