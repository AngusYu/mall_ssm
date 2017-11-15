package cn.angusyu.mall.dto;

/**
 * @author AngusYu
 */
public class OperationResult {
    private String operation;
    private Integer status;

    public OperationResult(String operation, Integer status) {
        this.operation = operation;
        this.status = status;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "OperationResult{" +
                "operation='" + operation + '\'' +
                ", status=" + status +
                '}';
    }
}
