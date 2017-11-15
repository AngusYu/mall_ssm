package cn.angusyu.mall.controller.frontend;

import cn.angusyu.mall.entity.User;
import cn.angusyu.mall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

/**
 * @author AngusYu
 */
@Controller
@RequestMapping(value = "frontend/")
public class FrontendIndexController {

    @Autowired
    private UserService userService;

    @RequestMapping
    public String redirect() {
        return "redirect:/frontend/home";
    }

    @RequestMapping(value = "home")
    public ModelAndView home(){
        return new ModelAndView("/frontend/main/home");
    }

    @RequestMapping(value = "login")
    public ModelAndView login() {
        return new ModelAndView("/frontend/main/login");
    }

    @RequestMapping(value = "login/verify")
    public String verifyLogin(@RequestParam("loginName") String loginName, @RequestParam("password")String password, Model model, HttpSession httpSession){
        User user;
        int s=userService.login(loginName,password);
        if (s==1){
            user=userService.getUserByLoginName(loginName);
            httpSession.setAttribute("user",user);
            return "redirect:/frontend/home";
        }else {
            model.addAttribute("errorMsg","登录名或密码错误");
            return "frontend/main/login";
        }
    }

    @RequestMapping(value = "logout")
    public String logout(HttpSession httpSession){
        httpSession.removeAttribute("user");
        return "redirect:/frontend/home";
    }

    @RequestMapping(value = "register")
    public String register(){
        return "/frontend/main/register";
        //todo
    }

    @RequestMapping(value = "register/success")
    public String registerSuccess(){
        return "/frontend/main/registerSuccess";
    }

}
