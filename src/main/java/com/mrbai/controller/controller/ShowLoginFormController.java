package com.mrbai.controller.controller;

import com.mrbai.controller.exception.IncorrectCaptchaException;
import org.apache.shiro.authc.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by MirBai
 * on 2016/5/2.
 */
@Controller
@RequestMapping("/test")
public class ShowLoginFormController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @RequestMapping("/toLogin")
    public String showLoginForm(HttpServletRequest request, Model model){
        model.addAttribute("account", request.getParameter("account"));
        String exceptionName = (String) request.getAttribute("shiroLoginFailure");
        String error = null;
        if(exceptionName != null ){
            System.out.println(IncorrectCaptchaException.class.getClass().getName());
            if(IncorrectCaptchaException.class.getName().equals(exceptionName)) {
                error = "验证码错误";
            } else if(UnknownAccountException.class.getName().equals(exceptionName)) {
                error = "用户名/密码错误";
            } else if(IncorrectCredentialsException.class.getName().equals(exceptionName)) {
                error = "用户名/密码错误";
            } else if(ExcessiveAttemptsException.class.getName().equals(exceptionName)) {
                error = "尝试次数已经超过5次，请一个小时后再试";
            } else if(LockedAccountException.class.getName().equals(exceptionName)) {
                error = "您的帐号已经锁定，暂时不允许登录，请联系管理员";
            }else if(exceptionName != null) {
                error = "登录失败，错误信息：" + exceptionName;
            }
        }
        if(error != null){
            logger.info("用户尝试登录系统失败  登录账号：{} 错误信息：{}",request.getParameter("account"),error);
        }
        model.addAttribute("error", error);
        return "login";
    }
}
