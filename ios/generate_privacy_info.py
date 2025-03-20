import os
import plistlib

# Pods 目录，扫描所有 pod 依赖
PODS_DIR = "./Pods"
OUTPUT_FILE = "PrivacyInfo.xcprivacy"

def find_xcprivacy_files():
    """遍历 Pods 目录，查找所有 Pod 的 PrivacyInfo.xcprivacy 文件"""
    xcprivacy_files = []
    for root, _, files in os.walk(PODS_DIR):
        for file in files:
            if file == "PrivacyInfo.xcprivacy":
                xcprivacy_files.append(os.path.join(root, file))
    return xcprivacy_files

def merge_xcprivacy_files(file_paths):
    """合并所有 PrivacyInfo.xcprivacy 的数据"""
    merged_data = {
        "NSPrivacyAccessedAPITypes": [],
        "NSPrivacyCollectedDataTypes": [],
        "NSPrivacyTrackingDomains": [],
        "NSPrivacyTracking": False  # 默认不开启跟踪
    }

    for file_path in file_paths:
        try:
            with open(file_path, "rb") as f:
                privacy_data = plistlib.load(f)  # 解析 Plist (XML) 格式

            # 直接合并 `NSPrivacyAccessedAPITypes`
            if "NSPrivacyAccessedAPITypes" in privacy_data:
                merged_data["NSPrivacyAccessedAPITypes"].extend(privacy_data["NSPrivacyAccessedAPITypes"])
            
            # 直接合并 `NSPrivacyCollectedDataTypes`
            if "NSPrivacyCollectedDataTypes" in privacy_data:
                merged_data["NSPrivacyCollectedDataTypes"].extend(privacy_data["NSPrivacyCollectedDataTypes"])
            
            # 直接合并 `NSPrivacyTrackingDomains`
            if "NSPrivacyTrackingDomains" in privacy_data:
                merged_data["NSPrivacyTrackingDomains"].extend(privacy_data["NSPrivacyTrackingDomains"])
            
            # 如果任何 Pod 需要 `NSPrivacyTracking`，最终结果应为 True
            if privacy_data.get("NSPrivacyTracking", False):
                merged_data["NSPrivacyTracking"] = True

        except Exception as e:
            print(f"⚠️ 无法解析 {file_path}: {str(e)}")

    return merged_data

def write_merged_xcprivacy(data):
    """写入合并后的 PrivacyInfo.xcprivacy 文件 (Plist 格式)"""
    with open(OUTPUT_FILE, "wb") as f:
        plistlib.dump(data, f)
    print(f"✅ 生成 {OUTPUT_FILE}")

if __name__ == "__main__":
    xcprivacy_files = find_xcprivacy_files()
    if not xcprivacy_files:
        print("⚠️ 未找到任何 PrivacyInfo.xcprivacy 文件")
    else:
        merged_data = merge_xcprivacy_files(xcprivacy_files)
        write_merged_xcprivacy(merged_data)
