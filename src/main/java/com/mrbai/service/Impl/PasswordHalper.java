package com.mrbai.service.Impl;

import com.mrbai.entity.TUser;
import org.apache.shiro.crypto.RandomNumberGenerator;
import org.apache.shiro.crypto.SecureRandomNumberGenerator;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.util.ByteSource;
import org.springframework.stereotype.Service;

/**
 * Created by MirBai
 * on 2016/5/1.
 * TODO : 对新注册的 TUser 对象进行密码加密处理,利用 shiro 加密规则(需要通过配置spring-shiro.xml文件),
 */
@Service
public class PasswordHalper {

    private RandomNumberGenerator randomNumberGenerator = new SecureRandomNumberGenerator();

    public RandomNumberGenerator getRandomNumberGenerator() {
        return randomNumberGenerator;
    }

    public void setRandomNumberGenerator(RandomNumberGenerator randomNumberGenerator) {
        this.randomNumberGenerator = randomNumberGenerator;
    }

    public void encryptPassword(TUser tUser){
        tUser.setSalt(randomNumberGenerator.nextBytes().toHex());
        String newPassword = new SimpleHash("md5",tUser.getPassword(), ByteSource.Util.bytes(tUser.getCredentialsSalt()),1).toHex();
        tUser.setPassword(newPassword);
    }
}
