package com.mrbai.controller.controller;

import com.mrbai.controller.exception.IncorrectCaptchaException;
import com.mrbai.entity.TRole;
import com.mrbai.entity.TUser;
import com.mrbai.service.RoleService;
import com.mrbai.service.UserService;
import com.mrbai.shiro.CaptchaUsernamePasswordToken;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.subject.Subject;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by MirBai
 * on 2016/4/24.
 * TODO 注册，登录，登出方法写在此类
 */
@Controller
@RequestMapping("/user")
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Resource(name = "userServiceImpl")
    UserService userService;

    @Resource(name = "roleServiceImpl")
    RoleService roleService;

    ObjectMapper objectMapper = new ObjectMapper();

    /**
     * @param tUser
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/25 20:50
     * @Method AuthcLogin
     * @Return
     * @TODO 验证用户名密码是否匹配, 如匹配, 登录成功, 进入 main.jsp,如不匹配，跳转到 user/login 路径下
     * @notice
     */
    /*@RequestMapping(value = "/AuthcLogin", method = RequestMethod.POST)
    public String AuthcLogin(TUser tUser,String code, RedirectAttributes attributes) {

        CaptchaUsernamePasswordToken token = new CaptchaUsernamePasswordToken(tUser.getAccount(), tUser.getPassword(),code);
        Subject subject = SecurityUtils.getSubject();
        try {
            subject.login(token);
            DateFormat dateFormat = new SimpleDateFormat("yyyy:MM:dd");
            String curentDate = dateFormat.format(new Date());
            logger.info("用户:{}   于:{}登录     登录状态:{}", tUser.getAccount(), curentDate, "登录成功");
            return "redirect:/material/toMain";
        } catch (UnknownAccountException e) {//没找到账号(不管密码匹配不匹配)
            e.printStackTrace();
            attributes.addFlashAttribute("error", "账号不存在");
            return "redirect:/user/login";
        } catch (IncorrectCredentialsException e) {//账号匹配,但是密码不匹配
            e.printStackTrace();
            attributes.addFlashAttribute("error", "账号密码不匹配");
            return "redirect:/user/login";
        }
    }*/

    /**
     * @param account
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/25 20:55
     * @Method verifyAccount
     * @Return
     * @TODO 验证用户是否已经被注册了
     * @notice count(*) 返回值是 Long 型
     */
    @RequestMapping(value = "/verifyAccount", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public
    @ResponseBody
    String verifyAccount(String account) {
        Long count = (Long) userService.getAccountCount(account);
        if (count < 1) {
            ReturnManager returnManager = new ReturnManager();
            returnManager.setStat(true);
            returnManager.setMsg("恭喜，用户名可用");
            try {
                String success = objectMapper.writeValueAsString(returnManager);
                return success;
            } catch (IOException e) {
                e.printStackTrace();
                return null;
            }
        } else {
            ReturnManager returnManager = new ReturnManager();
            returnManager.setStat(false);
            returnManager.setMsg("用户名已存在");
            try {
                String success = objectMapper.writeValueAsString(returnManager);
                return success;
            } catch (IOException e) {
                e.printStackTrace();
                return null;
            }
        }
    }

    /**
     * @param tUser
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/25 21:06
     * @Method register
     * @Return java.lang.String
     * @TODO 注册新用户
     * @notice
     */
    @RequestMapping("/register")
    public String register(TUser tUser) {
        java.sql.Date reg_date = new java.sql.Date(new Date().getTime());
        tUser.setRegDate(reg_date);

        String roleKey = "SUPER";
        TRole tRole = roleService.getRoleByRoleKey(roleKey);
        Set<TRole> tRoles = new HashSet<TRole>();
        tRoles.add(tRole);
        tUser.settRoles(tRoles);

        userService.registUser(tUser);
        logger.info("注册成功 账号:{} 注册时间:{}", tUser.getAccount(), reg_date);
        return "redirect:/material/toMain";
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET, produces = "text/html;charset=utf-8")
    public
    @ResponseBody
    String logout() {
        Subject subject = SecurityUtils.getSubject();
        String account = (String) subject.getPrincipal();
        subject.logout();
        ReturnManager returnManager = new ReturnManager();
        returnManager.setMsg("用户" + account + "退出成功");
        try {
            String success = objectMapper.writeValueAsString(returnManager);
            return success;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
