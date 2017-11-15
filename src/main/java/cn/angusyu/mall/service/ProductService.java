package cn.angusyu.mall.service;

import cn.angusyu.mall.dto.PaginationResult;
import cn.angusyu.mall.entity.Product;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.util.List;

/**
 * @author AngusYu
 */
public interface ProductService {

    Integer insertProduct(Product product, String path, CommonsMultipartFile picture);

    Integer deleteProductByIds(List<Long> ids);

    Integer updateProduct(Product product, String path, CommonsMultipartFile picture);

    Product getProductById(Long id);

    PaginationResult listProducts(Integer page, Integer rows, String fuzzyParam);

    Boolean checkProductName(String name);
}
