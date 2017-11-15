package cn.angusyu.mall.interceptor;

import cn.angusyu.mall.entity.Admin;
import cn.angusyu.mall.entity.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.lang.Nullable;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;

/**
 * @author AngusYu
 */
public class BackendLoginInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession httpSession=request.getSession();
        String contextPath=httpSession.getServletContext().getContextPath();
        String[] noNeedForAuthenticatePage=new String[]{
                "login",
                "verify"
        };
        String shortUri=request.getRequestURI();
        shortUri= StringUtils.remove(shortUri,contextPath);
        if (shortUri.startsWith("/backend")){
            String pageName=StringUtils.substringAfterLast(shortUri,"/");
            if (!Arrays.asList(noNeedForAuthenticatePage).contains(pageName)){
                Admin admin=(Admin) httpSession.getAttribute("admin");
                if (admin==null){
                    response.sendRedirect("login");
                    return false;
                }
            }
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable ModelAndView modelAndView) throws Exception {
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws Exception {
    }

}
