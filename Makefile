# Makefile

# 路径变量
DATA_DIR := data
SCRIPTS_DIR := scripts

# 文件变量
PCAP_FILES := $(DATA_DIR)/consumer_capture.pcap
CSV_FILES := $(PCAP_FILES:.pcap=.csv)
THROUGHPUT_FILES := $(CSV_FILES:.csv=_throughput.csv)
PLOT_FILES := $(THROUGHPUT_FILES:.csv=.png)

# 目标：将PCAP文件转换为CSV文件
$(DATA_DIR)/%.csv: $(DATA_DIR)/%.pcap
	tshark -r $< -T fields -e frame.time_epoch -e frame.len -E header=y -E separator=, -E quote=d > $@

# 目标：计算吞吐量
$(DATA_DIR)/%_throughput.csv: $(DATA_DIR)/%.csv
	python3 $(SCRIPTS_DIR)/throughput_calculation.py $<

# 目标：绘制吞吐量图
$(DATA_DIR)/%.png: $(DATA_DIR)/%_throughput.csv
	python3 $(SCRIPTS_DIR)/plot_throughput.py $<

# 主目标：生成折线图并清理中间文件
all: $(PLOT_FILES)
	$(MAKE) clean

# 清理生成的中间文件和输出文件
clean:
	rm -f $(CSV_FILES) $(THROUGHPUT_FILES)
