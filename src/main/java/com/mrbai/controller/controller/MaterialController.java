package com.mrbai.controller.controller;

import com.mrbai.entity.TRole;
import com.mrbai.entity.TUser;
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
import java.util.List;

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

    @RequestMapping(value = "/editUser", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
    public
    @ResponseBody String editUser(String userId, String userName, String email, String telephone, String roleName){
        TRole tRole = roleService.getRoleByRoleKey(roleName);
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

    @RequestMapping("/toMain")
    public String toMain(Model model){
        Subject subject = SecurityUtils.getSubject();
        String account = (String) subject.getPrincipal();
        model.addAttribute("account",account);
        return "main";
    }
}
