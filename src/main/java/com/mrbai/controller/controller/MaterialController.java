package com.mrbai.controller.controller;

import com.mrbai.controller.exception.IncorrectCaptchaException;
import com.mrbai.entity.TPermission;
import com.mrbai.entity.TRole;
import com.mrbai.entity.TUser;
import com.mrbai.service.PermissionSerice;
import com.mrbai.service.RoleService;
import com.mrbai.service.UserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.subject.Subject;
import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by MirBai
 * on 2016/4/26.
 */
@Controller
@RequestMapping("/material")
public class MaterialController {

    private static final Logger LOGGER = LoggerFactory.getLogger(MaterialController.class);

    @Resource(name = "userServiceImpl")
    UserService userService;

    @Resource(name = "roleServiceImpl")
    RoleService roleService;

    @Resource(name = "permissionServiceImpl")
    PermissionSerice permissionSerice;

    private ObjectMapper objectMapper = new ObjectMapper();
    JsonGenerator jsonGenerator;

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
            LOGGER.info("用户尝试登录系统失败  登录账号：{} 错误信息：{}",request.getParameter("account"),error);
        }
        model.addAttribute("error", error);
        return "login";
    }

    /* 用户管理 */
    @RequestMapping(value = "/getUserByPage", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public @ResponseBody String getUserByPage(int pageNo){
        List<TUser> tUsers = userService.getUserByPage(pageNo);
        if (tUsers != null){
            ReturnManager returnManager = new ReturnManager();
            returnManager.setMsg(tUsers);
            returnManager.setStat(true);
            try {
                String success = objectMapper.writeValueAsString(returnManager);
                return success;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /* 删除一条或多条用户信息 */
    @RequestMapping(value = "/deleteUser",method = RequestMethod.POST,produces = "text/html;charset=utf-8")
    public @ResponseBody String deleteUser(String userId){
        boolean retu = userService.deleteUser(userId);
        ReturnManager returnManager = new ReturnManager();
        if (retu = true){
            returnManager.setStat(true);
            returnManager.setMsg("删除成功");
            try {
                String success = objectMapper.writeValueAsString(returnManager);
                 return success;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /* 删除一条用户信息 */
    @RequestMapping(value = "/delUsers", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
    public @ResponseBody String delUsers(String userIds){

        //字符串转数组
        String[] userIdList = userIds.split(",");
        //遍历数组
       /* for (int i = 0; i < user.length; i++) {
            String s = user[i];
            System.out.println(s);
        }*/
        int count = userService.deleteUsers(userIdList);
        if (count == userIdList.length){
            ReturnManager returnManager = new ReturnManager();
            returnManager.setMsg("删除成功");
            returnManager.setStat(true);
            try {
                String success = objectMapper.writeValueAsString(returnManager);
                return success;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /* 更改用户信息 */
    @RequestMapping(value = "/editUser", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
    public
    @ResponseBody String editUser(String userId, String userName, String email, String telephone, String roleKey){
        TRole tRole = roleService.getRoleByRoleKey(roleKey);
        if (tRole != null){
            ReturnManager returnManager = new ReturnManager();
            Object[] values = new Object[]{userName, email, telephone, tRole, userId};
            int count = userService.editUser(values);
            if (count > 0){
                returnManager.setStat(true);
                returnManager.setMsg("修改成功");
                try {
                    String success = objectMapper.writeValueAsString(returnManager);
                    return success;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    /* get user count*/
    @RequestMapping("/searchUserCount")
    public @ResponseBody String searchUserCount(){
        Long count = userService.getUserCount();
        ReturnManager returnManager = new ReturnManager();
        returnManager.setMsg(count);
        returnManager.setStat(true);
        try {
            String success = objectMapper.writeValueAsString(returnManager);
            return success;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
    /* 角色管理 */
    @RequestMapping(value = "/getRoleByPage", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public @ResponseBody String getRoleByPage(int pageNo){
        List<TRole> tRoles = roleService.getRoleByPage(pageNo);
        if (tRoles != null){
            ReturnManager returnManager = new ReturnManager();
            returnManager.setMsg(tRoles);
            returnManager.setStat(true);
            try {
                String success = objectMapper.writeValueAsString(returnManager);
                return success;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /* 新增角色 */
    @RequestMapping(value = "addRole", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public @ResponseBody String addRole(String roleName,String roleKey,String description,ArrayList<TPermission> permissions,boolean flag){
        if (flag=true){
            TRole tRole = new TRole();
            tRole.setRoleName(roleName);
            tRole.setRoleKey(roleKey);
            tRole.setDescription(description);
            tRole.settPermissions(permissions);
            roleService.addRole(tRole);
            String roleId =tRole.getRoleId();
            if (roleId != null){
                ReturnManager returnManager = new ReturnManager();
                returnManager.setMsg(tRole);
                returnManager.setStat(true);
                try {
                    String success = objectMapper.writeValueAsString(returnManager);
                    return success;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return null;
        }
        return null;
    }

    /* 更改角色信息 */
    @RequestMapping(value = "editRole", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public @ResponseBody String editRole(String roleName,String roleKey,String description,/*ArrayList<TPermission> permissions,*/boolean flag,String roleId){
        if (flag = true){
            Object[] roles = new Object[]{roleName,roleKey,description,/*permissions,*/roleId};
            int count = roleService.editRole(roles);
            if (count == 1){
                ReturnManager returnManager = new ReturnManager();
                returnManager.setMsg("更新用户信息成功");
                returnManager.setStat(true);
                try {
                    String success = objectMapper.writeValueAsString(returnManager);
                    return success;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    /* 删除角色信息 (暂不支持)*/
    @RequestMapping(value = "/deleteRole", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
    public @ResponseBody String deleteRole(String roleIds){
        int count = 0;
        if (roleIds.contains(",")){
            Object[] roleIdList = roleIds.split(",");
            count = roleService.deleteRole(roleIdList);
        }else {
            Object[] roleIdList = new Object[]{roleIds};
            count = roleService.deleteRole(roleIdList);
        }

        if (count > 0){
            ReturnManager returnManager = new ReturnManager();
            returnManager.setStat(true);
            returnManager.setMsg("删除成功");
            try {
                String success = objectMapper.writeValueAsString(returnManager);
                return success;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /* get role count*/
    @RequestMapping("/searchRoleCount")
    public @ResponseBody String searchRoleCount(){
        Long count = roleService.getRoleCount();
        ReturnManager returnManager = new ReturnManager();
        returnManager.setMsg(count);
        returnManager.setStat(true);
        try {
            String success = objectMapper.writeValueAsString(returnManager);
            return success;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    /* 查询指定用户所属角色拥有的权限*/
    @RequestMapping(value = "/checkPerm")
    public @ResponseBody String checkPerm(String roleId){
        TRole tRole = roleService.getRoleByRoleId(roleId);
        List<TPermission> tPermissions = tRole.gettPermissions();
        ReturnManager returnManager = new ReturnManager();
        if (tPermissions.size() > 0 && tPermissions != null){
            returnManager.setMsg(tPermissions);
            returnManager.setStat(true);
            try {
                String success = objectMapper.writeValueAsString(returnManager);
                return success;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }else if (tPermissions.size() < 1 || tPermissions == null){
            return "";
        }
        return null;
    }
    /* 为角色分配权限 */
    @RequestMapping(value = "/assignPerm", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
    public @ResponseBody String assignPerm(String roleId, String permNames, boolean flag){
        if (flag = true && roleId != null && !"".equals(roleId)){
            if ( permNames != null && !"".equals(permNames) ){
                if (permNames.contains(",")){
                    Object[] permNameList = permNames.split(",");
                /* 通过 perm_name 得到permission */
                    List<TPermission> tPermissions = permissionSerice.getPermissionByPermName(permNameList);
                    if (tPermissions != null && tPermissions.size() > 0){
                        roleService.updateRolePerm(roleId, tPermissions);
                        ReturnManager returnManager = new ReturnManager();
                        returnManager.setMsg("赋权成功");
                        returnManager.setStat(true);
                        try {
                            String success = objectMapper.writeValueAsString(returnManager);
                            return success;
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }else {
                    Object[] permNameList = new Object[]{permNames};
                    List<TPermission> tPermissions = permissionSerice.getPermissionByPermName(permNameList);
                    if (tPermissions != null && tPermissions.size() > 0){
                        roleService.updateRolePerm(roleId, tPermissions);
                        ReturnManager returnManager = new ReturnManager();
                        returnManager.setMsg("赋权成功");
                        returnManager.setStat(true);
                        try {
                            String success = objectMapper.writeValueAsString(returnManager);
                            return success;
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }else if (permNames == null || "".equals(permNames)){
                roleService.updateRolePerm(roleId, null);
                ReturnManager returnManager = new ReturnManager();
                returnManager.setMsg("赋权成功");
                returnManager.setStat(true);
                try {
                    String success = objectMapper.writeValueAsString(returnManager);
                    return success;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }
}
