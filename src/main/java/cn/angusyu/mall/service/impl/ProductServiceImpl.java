package cn.angusyu.mall.service.impl;

import cn.angusyu.mall.dao.CategoryDao;
import cn.angusyu.mall.dao.ProductDao;
import cn.angusyu.mall.dto.PaginationResult;
import cn.angusyu.mall.entity.Product;
import cn.angusyu.mall.service.ProductService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.*;

import static cn.angusyu.mall.util.Constant.*;

/**
 * @author AngusYu
 */
@Service
public class ProductServiceImpl implements ProductService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ProductDao productDao;
    @Autowired
    private CategoryDao categoryDao;

    @Override
    public Integer insertProduct(Product product, String path, CommonsMultipartFile picture) {
        Product p = verifyInsertProduct(product);
        int s;
        if (p != null) {
            logger.info("insertProduct: product for insert has been verified.");
            p.setImageSrc(processPicture(path,picture));
            s = productDao.insertProduct(p);
            if (s == 1) {
                categoryDao.updateIncreaseProductAmountById(p.getCategory().getId());
            }
            return s;
        }
        return -1;
    }

    @Override
    public Integer deleteProductByIds(List<Long> ids) {
        List<Long> i = verifyAndFixIds(ids);
        if (i != null) {
            logger.info("deleteProductByIds: ids for updateDelete has been verified, try updateDelete.");
            for (int j = 0; j < i.size(); j++) {
                categoryDao.updateDecreaseProductAmountById(productDao.getCategoryIdById(i.get(j)));
            }
            return productDao.updateDeleteByIds(i);
        }
        return -1;
    }

    @Override
    public Integer updateProduct(Product product, String path, CommonsMultipartFile picture) {
        product.setImageSrc(processPicture(path,picture));
        Product p = verifyUpdateProduct(product);
        if (p != null) {
            logger.info("updateProduct: product for update has been verified.");
            return productDao.updateProduct(p);
        }
        return -1;
    }

    @Override
    public Product getProductById(Long id) {
        if (id != null && id > ZERO_ID) {
            return productDao.getById(id);
        }
        return null;
    }

    @Override
    public PaginationResult listProducts(Integer page, Integer rows, String fuzzyParam) {
        if (page == null || rows == null) {
            page = 1;
            rows = 15;
        }
        PageInfo pageInfo;
        List<Product> products;
        PageHelper.startPage(page, rows);
        if (fuzzyParam == null || "".equals(fuzzyParam)) {
            products = productDao.listAll();
        } else {
            products = productDao.listAllQueryByFuzzyParam(fuzzyParam);
        }
        pageInfo = new PageInfo<>(products);
        return new PaginationResult(pageInfo.getTotal(), products);
    }

    @Override
    public Boolean checkProductName(String name) {
        boolean isNameValid = name.length() > 0 && name.length() <= VARCHAR_MAX_LENGTH_20;
        if (isNameValid) {
            isNameValid = productDao.getIdByName(name) == null;
        }
        return isNameValid;
    }

    private Product verifyInsertProduct(Product product) {
        boolean isNameNotNull;
        boolean isCategoryIdNotNull;
        boolean isNameValid = false;
        boolean isCategoryIdValid = false;
        if (product != null) {
            isNameNotNull = product.getName() != null && !"".equals(product.getName());
            isCategoryIdNotNull = product.getCategory() != null && product.getCategory().getId() != null && product.getCategory().getId() != ZERO_ID;
            if (isNameNotNull) {
                if (product.getName().length() > VARCHAR_MAX_LENGTH_100) {
                    //  if name is too long, substring to 100 word
                    product.setName(product.getName().substring(0, VARCHAR_MAX_LENGTH_100));
                    logger.info("product.name is too long, cut out to 100 word by left.");
                }
                //  name can't be duplicate in database
                isNameValid = productDao.getIdByName(product.getName()) == null;
                logger.info("isNameValid:" + isNameValid);
                if (!isNameValid) {
                    return null;
                }
            }
            if (isCategoryIdNotNull) {
                if (product.getCategory().getId() < ZERO_ID) {
                    //  ID can't be negative
                    product.getCategory().setId(Math.abs(product.getCategory().getId()));
                    logger.info("product.category.id is negative, fixed to positive value.");
                }
                //  category.id must be exist in database
                isCategoryIdValid = categoryDao.getIdById(product.getCategory().getId()) != null;
                logger.info("isCategoryIdValid:" + isCategoryIdValid);
                if (!isCategoryIdValid) {
                    return null;
                }
            }
            if (isNameValid && isCategoryIdValid) {
                boolean isPriceNotNull = product.getPrice() != null;
                boolean isStockNotNull = product.getStock() != null;
                if (isPriceNotNull && isStockNotNull) {
                    //  price and stock can't be negative
                    if (product.getPrice() < PRICE_MIN_VALUE) {
                        product.setPrice(Math.abs(product.getPrice()));
                        logger.info("product.price is negative, fixed to positive value.");
                    }
                    if (product.getStock() < STOCK_MIN_VALUE) {
                        product.setStock(Math.abs(product.getStock()));
                        logger.info("product.stock is negative, fixed to positive value");
                    }
                    return fixUnnecessaryProperty(product);
                }
            }
        }
        return null;
    }

    private Product fixUnnecessaryProperty(Product product) {
        int l;
        //  TEXT can't be longer than TEXT_MAN_LENGTH
        if (product.getBriefIntro() != null) {
            l = product.getBriefIntro().length();
            if (l > TEXT_MAX_LENGTH) {
                product.setBriefIntro(product.getBriefIntro().substring(0, TEXT_MAX_LENGTH));
                logger.info("product.briefIntro is too long, cut out to 65536 word by left.");
            }
        }
        if (product.getDetailInfo() != null) {
            l = product.getDetailInfo().length();
            if (l > TEXT_MAX_LENGTH) {
                product.setDetailInfo(product.getDetailInfo().substring(0, TEXT_MAX_LENGTH));
                logger.info("product.detailInfo is too long, cut out to 65536 word by left.");
            }
        }
        return product;
    }

    private String processPicture(String path,CommonsMultipartFile picture){
        if (!picture.isEmpty()){
            String fileExtension=picture.getOriginalFilename().substring(picture.getOriginalFilename().lastIndexOf('.'));
            String newFileName;
            if (!"".equals(fileExtension)){
                newFileName="time"+System.currentTimeMillis()+fileExtension;
                File newFile=new File(path,newFileName);
                try {
                    picture.transferTo(newFile);
                    return newFileName;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return "";
    }

    private List<Long> verifyAndFixIds(List<Long> ids) {
        Set idSet = null;
        //  remove null first
        ids.removeAll(Collections.singleton(null));
        //  set negative value to ZERO_ID
        for (int i = 0; i < ids.size(); i++) {
            if (ids.get(i) < ZERO_ID) {
                ids.set(i, ZERO_ID);
            }
        }
        //  remove duplicate value
        idSet = new HashSet(ids);
        //  remove ZERO_ID
        idSet.remove(ZERO_ID);
        logger.info("After filter null, negative, duplicate and ZERO_ID item:" + idSet.toString());
        ids.clear();
        if (idSet.size() > 0) {
            for (Object o : idSet) {
                if (productDao.getIdById((Long) o) != null) {
                    ids.add((Long) o);
                }
            }
            logger.info("After filter non exist item:" + ids.toString());
            if (ids.size() > 0) {
                return ids;
            }
        }
        return null;
    }

    private Product verifyUpdateProduct(Product product) {
        boolean isIdNotNull;
        if (product != null) {
            //  ZERO_ID is not allowed
            isIdNotNull = product.getId() != null && product.getId() != ZERO_ID;
            logger.info("isIdNotNull:" + isIdNotNull);
            //  negative id is not allowed
            if (isIdNotNull && product.getId() > ZERO_ID) {
                //  id must be exist in database first
                Long idById = productDao.getIdById(product.getId());
                Long idByName;
                logger.info("idById:" + idById);
                if (idById != null) {
                    boolean isNameNotNull = product.getName() != null;
                    if (isNameNotNull) {
                        int l = product.getName().length();
                        //  if product.name is empty, set product.name to null.
                        if (l == 0) {
                            product.setName(null);
                        } else {
                            //  product.name is too long.
                            if (l > VARCHAR_MAX_LENGTH_100) {
                                product.setName(product.getName().substring(0, VARCHAR_MAX_LENGTH_100));
                                logger.info("product.name is too long, cut out to 100 word by left.");
                            }
                            idByName = productDao.getIdByName(product.getName());
                            //  product.name is ether not modified or duplicate
                            if (idByName != null) {
                                if (idByName.equals(idById)) {
                                    logger.info("product.name is not modified, set to null");
                                } else {
                                    logger.info("product.name is duplicate, set to null");
                                }
                                product.setName(null);
                            }
                        }
                    }

                    boolean isCategoryIdNotNull = product.getCategory() != null && product.getCategory().getId() != null;
                    boolean isCategoryIdInvalid;
                    Long pId;
                    if (isCategoryIdNotNull) {
                        pId = product.getCategory().getId();
                        if (pId > ZERO_ID) {
                            //  product.category.id must be exist in category table
                            isCategoryIdInvalid = categoryDao.getIdById(product.getCategory().getId()) == null;
                            if (isCategoryIdInvalid) {
                                logger.info("product.category.id is not exist, set to null");
                                product.setCategory(null);
                            }
                        } else {
                            product.setCategory(null);
                        }
                    }

                    //  negative price is not allowed
                    if (product.getPrice() != null) {
                        if (product.getPrice() < PRICE_MIN_VALUE) {
                            logger.info("product.price is negative, set to null.");
                            product.setPrice(null);
                        }
                    }

                    //  stock can't be negative
                    if (product.getStock() != null) {
                        if (product.getStock() < STOCK_MIN_VALUE) {
                            product.setStock(null);
                        }
                    }

                    Product fixedProduct = fixUnnecessaryProperty(product);
                    boolean fixedProductNotAllNull = fixedProduct.getAvailable() != null
                            || fixedProduct.getRecommended() != null
                            || fixedProduct.getPrice() != null
                            || fixedProduct.getStock() != null
                            || fixedProduct.getName() != null
                            || fixedProduct.getImageSrc() != null
                            || (fixedProduct.getCategory() != null && fixedProduct.getCategory().getId() != null)
                            || fixedProduct.getProductionDate() != null
                            || fixedProduct.getExpirationDate() != null
                            || fixedProduct.getBriefIntro() != null
                            || fixedProduct.getDetailInfo() != null;
                    if (fixedProductNotAllNull) {
                        return fixedProduct;
                    } else {
                        logger.info("Empty product for update, return null.");
                    }

                }
            }
        }
        return null;
    }

}
