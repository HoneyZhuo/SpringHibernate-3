package com.mrbai.controller.controller;

import com.mrbai.controller.exception.IncorrectCaptchaException;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.subject.Subject;
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
@RequestMapping("/toMain")
public class ToMainController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @RequestMapping("/main")
    public String toMain(Model model){
        Subject subject = SecurityUtils.getSubject();
        String account = (String) subject.getPrincipal();
        model.addAttribute("account",account);
        return "main";
    }
}
