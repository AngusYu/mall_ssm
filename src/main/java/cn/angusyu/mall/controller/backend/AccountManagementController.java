package cn.angusyu.mall.controller.backend;

import cn.angusyu.mall.dto.PaginationResult;
import cn.angusyu.mall.entity.Admin;
import cn.angusyu.mall.entity.User;
import cn.angusyu.mall.service.AdminService;
import cn.angusyu.mall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

/**
 * @author AngusYu
 */
@Service
@RequestMapping(value = "backend/management/account")
public class AccountManagementController {

    @Autowired
    private UserService userService;
    @Autowired
    private AdminService adminService;

    /**
     * User
     */
    @RequestMapping(value = "user")
    public ModelAndView toUser() {
        return new ModelAndView("/backend/main/user");
    }

    @RequestMapping(value = "user/check")
    @ResponseBody
    public Boolean checkUserLoginName(@RequestParam("loginName") String loginName) {
        return userService.checkUserLoginName(loginName);
    }

    @RequestMapping(value = "user/list", produces = {"application/json; charset=utf-8"})
    @ResponseBody
    public PaginationResult listUser(Integer page, Integer rows, String fuzzyParam) {
        return userService.listUsers(page, rows, fuzzyParam);
    }

    @RequestMapping(value = "user/add")
    @ResponseBody
    public Integer addUser(User user) {
        return userService.insertUser(user);
    }

    @RequestMapping(value = "user/delete")
    @ResponseBody
    public Integer deleteUser(@RequestParam("ids") List<Long> ids) {
        return userService.deleteUserByIds(ids);
    }

    @RequestMapping(value = "user/update")
    @ResponseBody
    public Integer updateUser(User user) {
        return userService.updateUser(user);
    }

    /**
     * Admin
     */
    @RequestMapping(value = "admin")
    public ModelAndView toAdmin() {
        return new ModelAndView("/backend/main/admin");
    }

    @RequestMapping(value = "admin/check")
    @ResponseBody
    public Boolean checkAdminLoginName(@RequestParam("loginName") String loginName) {
        return adminService.checkAdminLoginName(loginName);
    }

    @RequestMapping(value = "admin/list", produces = {"application/json; charset=utf-8"})
    @ResponseBody
    public PaginationResult listAdmin(Integer page, Integer rows, String fuzzyParam) {
        return adminService.listAdmins(page, rows, fuzzyParam);
    }

    @RequestMapping(value = "admin/add")
    @ResponseBody
    public Integer addAdmin(Admin admin) {
        return adminService.insertAdmin(admin);
    }

    @RequestMapping(value = "admin/delete")
    @ResponseBody
    public Integer deleteAdmin(@RequestParam("ids") List<Long> ids) {
        return adminService.deleteAdminByIds(ids);
    }

    @RequestMapping(value = "admin/update")
    @ResponseBody
    public Integer updateAdmin(Admin admin) {
        return adminService.updateAdmin(admin);
    }
}
