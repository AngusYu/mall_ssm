package cn.angusyu.mall.controller.backend;

import cn.angusyu.mall.entity.Admin;
import cn.angusyu.mall.entity.User;
import cn.angusyu.mall.service.AdminService;
import cn.angusyu.mall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

/**
 * @author AngusYu
 */
@Controller
@RequestMapping(value = "backend/")
public class BackendIndexController {

    @Autowired
    private AdminService adminService;

    @RequestMapping(value = "")
    public String redirect() {
        return "redirect:/backend/index";
    }

    @RequestMapping(value = "index")
    public ModelAndView index(HttpSession httpSession) {
        ModelAndView modelAndView=new ModelAndView("backend/main/index");
        Admin admin=(Admin) httpSession.getAttribute("admin");
        modelAndView.addObject("admin.loginName",admin.getLoginName());
        return modelAndView;
    }

    @RequestMapping(value = "login")
    public ModelAndView login() {
        return new ModelAndView("backend/main/login");
    }

    @RequestMapping(value = "login/verify")
    @ResponseBody
    public Integer verifyLogin(@RequestParam("loginName") String loginName, @RequestParam("password") String password, HttpSession httpSession) {
        Admin admin;
        int status = adminService.login(loginName,password);
        if (status == 1) {
            admin = adminService.getAdminByLoginName(loginName);
            httpSession.setAttribute("admin", admin);
        }
        return status;
    }

    @RequestMapping(value = "logout")
    public String logout(HttpSession httpSession){
        httpSession.removeAttribute("admin");
        return "redirect:login";
    }
}
