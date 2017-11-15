package cn.angusyu.mall.controller.backend;

import cn.angusyu.mall.dto.PaginationResult;
import cn.angusyu.mall.entity.*;
import cn.angusyu.mall.service.CategoryService;
import cn.angusyu.mall.service.ProductService;
import cn.angusyu.mall.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import static cn.angusyu.mall.util.Constant.*;

/**
 * @author AngusYu
 */
@Controller
@RequestMapping(value = "backend/management/merchandise")
public class MerchandiseManagementController {

    @Autowired
    private CategoryService categoryService;
    @Autowired
    private ProductService productService;


    /**
     * Category
     */
    @RequestMapping(value = "category")
    public ModelAndView toCategory() {
        return new ModelAndView("/backend/main/category");
    }

    @RequestMapping(value = "category/check")
    @ResponseBody
    public Boolean checkCategoryName(@RequestParam("name") String name) {
        return categoryService.checkCategoryName(name);
    }

    @RequestMapping(value = "category/list", produces = {"application/json; charset=utf-8"})
    @ResponseBody
    public PaginationResult listCategory(Integer page, Integer rows, String fuzzyParam) {
        return categoryService.listCategories(page, rows, fuzzyParam);
    }

    @RequestMapping(value = "category/list/all", produces = {"application/json; charset=utf-8"})
    @ResponseBody
    public List<Category> listAllCategory() {
        return categoryService.listAllCategories();
    }

    @RequestMapping(value = "category/add")
    @ResponseBody
    public Integer addCategory(Category category) {
        return categoryService.insertCategory(category);
    }

    @RequestMapping(value = "category/delete")
    @ResponseBody
    public Integer deleteCategory(@RequestParam("ids") List<Long> ids) {
        return categoryService.deleteCategoryByIds(ids);
    }

    @RequestMapping(value = "category/update")
    @ResponseBody
    public Integer updateCategory(Category category) {
        return categoryService.updateCategory(category);
    }


    /**
     * Product
     */
    @RequestMapping(value = "product")
    public ModelAndView toProduct() {
        return new ModelAndView("/backend/main/product");
    }

    @RequestMapping(value = "product/check")
    @ResponseBody
    public Boolean checkProductName(@RequestParam("name") String name) {
        return productService.checkProductName(name);
    }

    @RequestMapping(value = "product/list", produces = {"application/json; charset=utf-8"})
    @ResponseBody
    public PaginationResult listProduct(Integer page, Integer rows, String fuzzyParam) {
        return productService.listProducts(page, rows, fuzzyParam);
    }

    @RequestMapping(value = "product/add",method = RequestMethod.POST)
    @ResponseBody
    public Integer addProduct(HttpServletRequest httpServletRequest, @RequestParam(value = "picture", required = false) CommonsMultipartFile picture, Product product) {
        String path=httpServletRequest.getServletContext().getRealPath("/resources/img/");
        return productService.insertProduct(product,path,picture);
    }

    @RequestMapping(value = "product/delete")
    @ResponseBody
    public Integer deleteProduct(@RequestParam("ids") List<Long> ids) {
        return productService.deleteProductByIds(ids);
    }

    @RequestMapping(value = "product/update")
    @ResponseBody
    public Integer updateProduct(HttpServletRequest httpServletRequest, @RequestParam(value = "picture", required = false) CommonsMultipartFile picture, Product product) {
        String path=httpServletRequest.getServletContext().getRealPath("/resources/img/");
        return productService.updateProduct(product,path,picture);
    }

}
