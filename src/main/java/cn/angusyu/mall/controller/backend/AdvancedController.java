package cn.angusyu.mall.controller.backend;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author AngusYu
 */
@Controller
@RequestMapping(value = "backend/advanced/")
public class AdvancedController {

    @RequestMapping(value = "admin")
    public ModelAndView to1() {
        return new ModelAndView("backend/main/advanced1");
    }

    @RequestMapping(value = "2")
    public ModelAndView to2() {
        return new ModelAndView("backend/main/advanced2");
    }

}
