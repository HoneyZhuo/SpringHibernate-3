package com.mrbai.controller.controller;

import com.mrbai.entity.TPermission;
import com.mrbai.entity.TRole;
import com.mrbai.entity.TUser;
import com.mrbai.service.PermissionSerice;
import com.mrbai.service.RoleService;
import com.mrbai.service.UserService;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.apache.shiro.subject.Subject;
import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by MirBai
 * on 2016/4/26.
 */
@Controller
@RequestMapping("/material")
public class MaterialController {

    private static final Logger logger = Logger.getLogger(MaterialController.class);

    @Resource(name = "userServiceImpl")
    UserService userService;

    @Resource(name = "roleServiceImpl")
    RoleService roleService;

    @Resource(name = "permissionServiceImpl")
    PermissionSerice permissionSerice;

    ObjectMapper objectMapper = new ObjectMapper();
    JsonGenerator jsonGenerator;

    /**
     *  @Author 白景川【baijc1234@126.com】
     *  @Date 2016/4/26 10:32
     *  @Method getUserByPage
     *  @Return java.lang.String
     *  @TODO
     *  @notice
     */

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
            logger.info(roleId);
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

    @RequestMapping("/toMain")
    public String toMain(Model model){
        Subject subject = SecurityUtils.getSubject();
        String account = (String) subject.getPrincipal();
        model.addAttribute("account",account);
        return "main";
    }
}
