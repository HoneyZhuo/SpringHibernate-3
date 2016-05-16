package com.mrbai.shiro;

import org.apache.shiro.authc.UsernamePasswordToken;

/**
 * Created by MirBai
 * on 2016/5/2.
 */
public class CaptchaUsernamePasswordToken extends UsernamePasswordToken {

    private String captcha;

    public CaptchaUsernamePasswordToken(String username, String password, String captcha,boolean rememberMe, String host) {
        super(username, password,rememberMe,host);
        this.captcha = captcha;
    }

    public String getCaptcha() {
        return captcha;
    }

    public void setCaptcha(String captcha) {
        this.captcha = captcha;
    }
}
