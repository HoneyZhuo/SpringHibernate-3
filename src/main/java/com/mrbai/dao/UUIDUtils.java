package com.mrbai.dao;

import java.util.UUID;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
public class UUIDUtils {

    public static String getUUID(){
        return UUID.randomUUID().toString().replace("-","");
    }
}
