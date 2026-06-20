#!/bin/bash

# =================== TOOL CÀI TIVI XIAOMI NỘI ĐỊA TS 08 T6 2026 ===================
SOURCE_DIR="/root/ios"
ADB_COMMAND="/usr/bin/adb"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'

BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BBLUE='\033[1;34m'
BMAGENTA='\033[1;35m'
BCYAN='\033[1;36m'
WHITE='\033[1;37m'

NC='\033[0m'
trap '$ADB_COMMAND disconnect >/dev/null 2>&1; exit' INT TERM

# =================== HÀM DÙNG CHUNG ===================
print_header() {
    clear
    echo
    echo -e "${CYAN}🚀 TOOL CÀI TIẾNG VIỆT CHO TIVI XIAOMI NỘI ĐỊA${NC}"
    echo -e "${GREEN}📞   Hotline: 0967.341.608 BY KHÁNH IT${NC}"
    echo -e "${WHITE}⚠️ Bản Cập Nhật: 08-06-2026 Phiên bản: 4.70${NC}"
    echo
}

check_adb() {
    if ! $ADB_COMMAND version >/dev/null 2>&1; then
        echo -e "${RED}❌ adb chưa sẵn sàng. Hãy chạy:${NC}"
        echo "apk add android-tools bash"
        exit 1
    fi
}

install_apk() {
    local apk_file="$1"
    if [ -f "$apk_file" ]; then
        echo -e "→ Đang Cài Ứng Dụng ${GREEN}$apk_file${NC}"
        if $ADB_COMMAND install -r -g "$apk_file"; then
            echo -e "${GREEN}✓ Đã Cài Thành Công${NC}"
        else
            echo -e "${RED}✗ Lỗi File Cài Thất bại${NC}"
        fi
    else
        echo -e "${RED}⚠ Không thấy File Cài $apk_file${NC}"
    fi
}

# =================== KIỂM TRA MÔI TRƯỜNG ===================
check_adb


# =================== MENU 1: KẾT NỐI TV ===================
menu1() {
    while true; do
        print_header
        echo -e "${BLUE}📡 MENU KẾT NỐI TIVI XIAOMI PRO${NC}"
        echo -e "${BLUE}────────────────────────────${NC}"
        echo ""
        echo -e "${MAGENTA}📺 HƯỚNG DẪN KẾT NỐI TIVI${NC}\n"
        echo -e "${CYAN}🎮 Điều khiển:${NC} ${YELLOW}↑ lên trên cùng${NC} → ${WHITE}Cài đặt ⚙${NC}"
        echo -e "${CYAN}🌐 Ngôn ngữ :${NC} ${YELLOW}↓ 4 lần${NC} → ${WHITE}Language${NC} → ${GREEN}English${NC}"
        echo -e "${CYAN}🔓 Developer:${NC} ${WHITE}About${NC} → ${YELLOW}Model${NC} → ${GREEN}OK 9 lần${NC}"
        echo -e "${CYAN}⚙️  Quyền    :${NC} ${GREEN}ADB Debugging${NC} + ${GREEN}Unknown Sources${NC}"
        echo -e "${CYAN}⛔ Lưu ý    :${NC} ${RED}Tắt Update tự động${NC}"
        echo -e "${CYAN}📶 Thiết bị :${NC} ${YELLOW}${DEVICE_IP}${NC} | ${GREEN}Android ${ANDROID}${NC}"
        echo ""
        echo -e "${BLUE}────────────────────────────${NC}"
        read -p "$(echo -e "${GREEN}📶 Nhập IP Tivi:${NC} ")" RAW_IP
        [ -z "$RAW_IP" ] && continue

        [[ "$RAW_IP" != *":5555" ]] && DEVICE_IP="${RAW_IP}:5555" || DEVICE_IP="$RAW_IP"

        local retry_count=0
        local max_retries=5
        local connected=false

        while [ $retry_count -le $max_retries ]; do
            echo -e "\n→ ${CYAN}Đang thử kết nối (Lần $((retry_count + 1)))...${NC}"
            
            $ADB_COMMAND disconnect >/dev/null 2>&1
            $ADB_COMMAND connect "$DEVICE_IP" >/dev/null 2>&1
            
            sleep 3 # Đợi TV nhận tín hiệu

            # Kiểm tra trạng thái thiết bị
            if $ADB_COMMAND devices | grep -q "$DEVICE_IP.*device"; then
                connected=true
                break
            else
                echo -e "${RED}✗ Bấm OK trên điều khiển để tích vào ô đồng ý...${NC}"
				echo -e "${RED}✗ Sau đó bấm phím xuống -> Sang phải -> Alown/OK${NC}"
                # Dùng let để tăng biến, tránh lỗi cú pháp
                let "retry_count++"
            fi
        done

        if [ "$connected" = true ]; then
            echo -e "${GREEN}✓ Kết nối thành công đến tivi !${NC}"
			echo -e "${GREEN}✓ Chào mừng bạn đến với MENU CÀI ĐẶT !${NC}"
			echo -e "📱 TV đang kết nối tại: ${GREEN}$DEVICE_IP${NC}"
            # Gán IP đã kết nối vào biến toàn cục để dùng cho menu2
            export DEVICE_IP
            sleep 1
            menu2
            break 
        else
            echo -e "${RED}⛔ Đã thử 6 lần thất bại. KIỂM TRA lại IP hoặc ADB Debugging trên TV ĐÃ BẬT CHƯA.${NC}"
			echo -e "${RED}⛔ Vui lòng kiểm tra lại IP hoặc BẤM ĐỒNG Ý CHO PHÉP ĐIỆN THOẠI KẾT NỐI ĐẾN TIVI.${NC}"
            sleep 5
            # Không dùng exit, chỉ tiếp tục vòng lặp while true để quay lại nhập IP
        fi
    done
}

# =================== MENU 2 ===================
menu2() {
    while true; do
        print_header
        echo -e "📱 TV đang kết nối tại: ${GREEN}$DEVICE_IP${NC}"
        echo
        # ===== THÔNG SỐ TIVI CHẠY TỰ DỘNG KHI KẾT NỐI THÀNH CÔNG =====
		MODEL=$(adb shell getprop ro.product.model | tr -d '\r')
        BRAND=$(adb shell getprop ro.product.brand | tr -d '\r')
        PANEL=$(adb shell getprop ro.boot.mi.panel_size 2>/dev/null | tr -d '\r')
        ANDROID=$(adb shell getprop ro.build.version.release | tr -d '\r')
        PATCH=$(adb shell getprop ro.build.version.security_patch | tr -d '\r')
        BUILD_SHOW=$(adb shell getprop ro.build.version.incremental | tr -d '\r')
        DATE=$(adb shell getprop ro.build.date | tr -d '\r')
        SERIAL=$(adb shell getprop ro.serialno | tr -d '\r')
		SDK=$(adb shell getprop ro.build.version.sdk | tr -d '\r')
		DEVICE=$(adb shell getprop ro.product.device | tr -d '\r')
		
		# Nếu không có PANEL thì gán mặc định
        [ -z "$PANEL" ] && PANEL="?"
		
		echo -e "${YELLOW}────────────────────────────────────────${NC}"
        echo -e "${CYAN}📺${NC} $MODEL ${GRAY}|${NC} ${YELLOW}$BRAND${NC} ${GRAY}|${NC} ${GREEN}Tivi (${PANEL} Inch)${NC}"
        echo -e "${CYAN}🤖${NC} Android $ANDROID ${GRAY}|${NC} ${BLUE}$BUILD_SHOW${NC}"
        echo -e "${CYAN}🆔${NC} $SERIAL|${NC} ${BLUE}SDK $SDK${NC}|${NC} $DEVICE ${GRAY}"
        echo -e "${CYAN}📅${NC} $DATE ${GRAY}|${NC} ${RED}$PATCH${NC}"
        echo -e "${YELLOW}────────────────────────────────────────${NC}"

        echo
        echo -e "${MAGENTA}📋 MENU CÀI ĐẶT GIAO DIỆN TIVI${NC}"
        echo
        echo -e "${CYAN}[- 1]${NC} 🚀 Cài Launcher ${GREEN}PROJECTIVY 9-11${NC}"
        echo -e "${CYAN}[- 2]${NC} 🚀 Cài Launcher ${GREEN}PROJECTIVY 14 2026${NC}"
        echo -e "${CYAN}[- 3]${NC} 📦 Cài tất cả ứng dụng ${YELLOW}(.apk)${NC} lên TV"
        echo -e "${CYAN}[- 4]${NC} 🖼️ Chép tất cả ảnh nền ${YELLOW}(.jpg, .png)${NC} vào TV"
        echo -e "${CYAN}[- 5]${NC} 🔄 Khởi động lại TV"
        echo -e "${CYAN}[- 6]${NC} ⚠️ ${RED}Khởi động vào XOÁ SẠCH DỮ LIỆU TIVI${NC}"
        echo -e "${CYAN}[- 7]${NC} ↩️  Quay lại menu kết nối"
        echo -e "${CYAN}[- 8]${NC} 🔓 Xin quyền ${GREEN}PROJECTIVY 14 2026${NC}"
        echo -e "${CYAN}[- 0]${NC} ❌ Thoát"
        echo
        read -p "🔄 → Nhập tùy chọn của bạn [0-8]: " CHOICE

        case $CHOICE in
            1) install_projectivy ;;
            2) install_X_S_2026 ;;
            3) install_all_apks ;;
            4) copy_wallpapers ;;
            5) reboot_tv "normal" ;;
            6) reboot_tv "recovery" ;;
            7) menu1; break ;; 
            8) permission ;; 
            0) echo "👋 Tạm biệt!"; exit 0 ;;
            *) echo -e "${YELLOW}⚠️ Lựa chọn không hợp lệ, vui lòng chọn lại.${NC}"; sleep 2 ;;
        esac
    done
}

# =================== CHỨC NĂNG ===================

# 1. Cài đặt Projectivy Launcher và các app đi kèm
install_projectivy() {
    echo -e "${YELLOW}📦 Đang cài đặt ${GREEN}Projectivy Launcher${YELLOW} cho Android ${WHITE}9-11${YELLOW}...${NC}"
    $ADB_COMMAND shell service call alarm 3 s16 Asia/Bangkok >/dev/null 2>&1
    $ADB_COMMAND shell settings put global device_locales vi-VN >/dev/null 2>&1
    $ADB_COMMAND shell settings put global sys_locale vi-VN >/dev/null 2>&1
    $ADB_COMMAND shell settings put system system_locales vi-VN >/dev/null 2>&1
    $ADB_COMMAND shell settings put global heads_up_notifications_enabled 0 >/dev/null 2>&1
    $ADB_COMMAND shell settings put global stay_on_while_plugged_in 3 >/dev/null 2>&1
    $ADB_COMMAND shell settings put global window_animation_scale 1 >/dev/null 2>&1
    $ADB_COMMAND shell settings put global transition_animation_scale 1 >/dev/null 2>&1
    $ADB_COMMAND shell settings put global animator_duration_scale 1 >/dev/null 2>&1
    echo "🚀 Bắt đầu cài đặt Projectivy Launcher..."
    echo "Đang chạy p.apk ..." >/dev/null 2>&1
    install_apk "p.apk" >/dev/null 2>&1

    $ADB_COMMAND shell monkey -p com.spocky.projengmenu -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
    $ADB_COMMAND shell am start -n com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1
    $ADB_COMMAND shell cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1

    local apps="com.mitv.tvhome com.mitv.gallery com.xiaomi.tweather com.mitv.screensaver 
        com.xiaomi.mitv.shop com.duokan.videodaily com.xiaomi.tv.gallery 
        com.mitv.cloudcontrol com.miui.tv.analytics com.xiaomi.voicecontrol 
        com.xiaomi.mitv.upgrade com.xiaomi.mitv.appstore com.xiaomi.mitv.calendar 
        com.xiaomi.mitv.handbook com.xiaomi.screenrecorder com.sohu.inputmethod.sogou.tv 
        com.xiaomi.mitv.karaoke.service com.xiaomi.mitv.hyper.screensaver com.android.tv.settings"

    for app in $apps; do
        $ADB_COMMAND shell pm disable-user --user 0 "$app" >/dev/null 2>&1
    done
   
    for app in $apps; do
        $ADB_COMMAND shell pm uninstall --user 0 "$app" >/dev/null 2>&1
    done

    local apks_to_install="mistore.apk keyboard.apk katniss_2.2.0.apk allapp.apk down.apk mitv.apk an.apk youtube.apk phim4k.apk getout.apk"

    echo "🚀 Bắt đầu cài đặt Thêm Các App cần thiết..."
    for apk in $apks_to_install; do
        install_apk "$apk"
    done
    
    $ADB_COMMAND push 470.plbackup /sdcard/Download >/dev/null 2>&1

    copy_wallpapers
    # Cấp quyền nâng cao cho ứng dụng
    # Danh sách ứng dụng (cách nhau bằng dấu cách)
    local app_list="com.spocky.projengmenu"

    # Danh sách quyền AppOps và Runtime Perms
    local appops_perms="REQUEST_INSTALL_PACKAGES WRITE_SETTINGS MANAGE_EXTERNAL_STORAGE"
    local runtime_perms="android.permission.READ_EXTERNAL_STORAGE android.permission.WRITE_EXTERNAL_STORAGE android.permission.READ_MEDIA_IMAGES android.permission.READ_MEDIA_VIDEO android.permission.READ_MEDIA_AUDIO"

    echo -e "${YELLOW}🔑 ĐANG CẤP QUYỀN GIAO DIỆN TIẾNG VIỆT...${NC}"

    # Đếm tổng số lượng app trong danh sách chuẩn POSIX
    local total_apps=0
    for pkg in $app_list; do
        total_apps=$((total_apps + 1))
    done

    local i=0
    for pkg in $app_list; do
        i=$((i + 1))
        
        # 1. Tính toán hiển thị thanh tiến trình Progress Bar
        local percent=$(( (i * 100) / total_apps ))
        local num_blocks=$(( (20 * i) / total_apps ))
        local num_dashes=$(( 20 - num_blocks ))
        
        # Tạo chuỗi kí tự chạy hình khối █
        local bar=""
        local b=0
        while [ $b -lt $num_blocks ]; do
            bar="${bar}█"
            b=$((b + 1))
        done
        local d=0
        while [ $d -lt $num_dashes ]; do
            bar="${bar}-"
            d=$((d + 1))
        done

        # In tiến trình cập nhật liên tục trên một dòng (\r)
        printf "\r  [%s] %d%% | %bCấp quyền:%b %s" "$bar" "$percent" "${CYAN}" "${NC}" "$pkg"

        # 2. Cấp quyền đặc biệt qua AppOps
        for perm in $appops_perms; do
            $ADB_COMMAND shell appops set "$pkg" "$perm" allow >/dev/null 2>&1
        done

        # 3. Cấp quyền Runtime qua PM Grant
        for perm in $runtime_perms; do
            $ADB_COMMAND shell pm grant "$pkg" "$perm" >/dev/null 2>&1
        done

        # 4. Buộc dừng ứng dụng để hệ thống Android cập nhật quyền ngay lập tức
        $ADB_COMMAND shell am force-stop "$pkg" >/dev/null 2>&1
    done
    
    sleep 1
    # Dọn dẹp dòng ghi đè và báo thành công
    printf "\r%100s\r" " "
    echo -e "${GREEN}✅ Đã cấp quyền và đồng bộ hóa $total_apps ứng dụng!${NC}"

    # Định nghĩa chuỗi chứa các lệnh cấu hình đặc biệt cho TV (mỗi lệnh cách nhau bằng dấu sổ đứng |)
    local list_xs_a14="cmd package clear-app-profiles com.mitv.tvhome|\
     pm grant com.mitv.shareds android.permission.WRITE_SECURE_SETTINGS|\
     pm grant com.mitv.shareds android.permission.CHANGE_CONFIGURATION|\
     pm grant com.spocky.projengmenu android.permission.WRITE_EXTERNAL_STORAGE|\
     pm grant com.spocky.projengmenu android.permission.READ_EXTERNAL_STORAGE|\
     pm grant com.spocky.projengmenu android.permission.WRITE_SECURE_SETTINGS|\
     appops set com.google.android.katniss SYSTEM_ALERT_WINDOW allow|\
     cmd appops set com.spocky.projengmenu WRITE_EXTERNAL_STORAGE allow|\
     cmd appops set com.spocky.projengmenu READ_EXTERNAL_STORAGE allow|\
     appops set com.spocky.projengmenu REQUEST_INSTALL_PACKAGES allow|\
     ime enable com.liskovsoft.leankeyboard/.ime.LeanbackImeService|\
     settings put secure default_input_method com.liskovsoft.leankeyboard/.ime.LeanbackImeService|\
     settings put secure enabled_accessibility_services com.mitv.shareds/com.mitv.shareds.HomeService|\
     settings put secure accessibility_enabled 1|\
     cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity"

    # Đổi dấu phân tách vòng lặp mặc định (IFS) sang dấu sổ đứng | để đọc trọn vẹn cả câu lệnh có chứa dấu cách
    local OLD_IFS="$IFS"
    IFS="|"

    # Chạy vòng lặp duyệt qua từng lệnh và thực thi adb shell trên TV
    for cmd in $list_xs_a14; do
        # Tránh thực thi nếu dòng bị trống
        [ -z "$cmd" ] && continue
        
        # Gửi lệnh adb shell ẩn log ra màn hình
        $ADB_COMMAND shell "$cmd" >/dev/null 2>&1
    done

    # Trả lại cấu hình IFS mặc định cho hệ thống tránh lỗi các vòng lặp khác
    IFS="$OLD_IFS"
    # Xóa dòng trạng thái cũ bằng cách ghi đè 115 khoảng trắng và in thông báo hoàn tất
    printf "\r%115s\r" " "
    echo -e "${GREEN}✅ Đã hoàn tất toàn bộ cấu hình hệ thống nâng cao!${NC}"
    
    # CHÈN CÁC LỆNH KHÓA ĐUÔI VÀ TỐI ƯU RIÊNG PROJECTIVY LAUNCHER
    echo -e "\n${YELLOW}⚡ Đang tối ưu hóa riêng Projectivy Launcher...${NC}"

    # 1. Tối ưu hóa tốc độ khởi chạy riêng cho Projectivy
    $ADB_COMMAND shell cmd package compile -m speed -f com.spocky.projectivylauncher >/dev/null 2>&1

    # 2. Cấp quyền cài đặt ứng dụng từ nguồn ngoài
    $ADB_COMMAND shell settings put global install_non_market_apps 1 >/dev/null 2>&1

    echo -e "\n${YELLOW}🔄 Đang ghi dữ liệu bảo mật và đồng bộ ổ cứng TV...${NC}"
    
    # 4. Ép hệ thống flush dữ liệu từ RAM xuống file cấu hình vật lý
    $ADB_COMMAND shell settings list secure >/dev/null 2>&1
    $ADB_COMMAND shell sync >/dev/null 2>&1
    
    echo -e "${GREEN}✅ Cài đặt Projectivy hoàn tất!${NC}"
    echo "Đang gửi lệnh khởi động lại..."
    $ADB_COMMAND reboot >/dev/null 2>&1 &
    
    # Giải phóng tiến trình ngầm để tránh terminal bị treo đợi phản hồi từ TV
    PID=$!
    sleep 1
    kill $PID >/dev/null 2>&1
    
    echo -e "${GREEN}✅ Hoàn tất MENU 2!${NC}"
    sleep 2
    menu1
}

# 2. Cài đặt X S 2026 và các app đi kèm
install_X_S_2026() {
   echo "🚀 Đang cài giao diện tiếng Việt Project Android 14..."
   $ADB_COMMAND shell service call alarm 3 s16 Asia/Bangkok >/dev/null 2>&1
   $ADB_COMMAND shell settings put global device_locales vi-VN >/dev/null 2>&1
   $ADB_COMMAND shell settings put global sys_locale vi-VN >/dev/null 2>&1
   $ADB_COMMAND shell settings put system system_locales vi-VN >/dev/null 2>&1
   $ADB_COMMAND shell settings put global heads_up_notifications_enabled 0 >/dev/null 2>&1
   $ADB_COMMAND shell settings put global stay_on_while_plugged_in 3 >/dev/null 2>&1
   $ADB_COMMAND shell settings put global window_animation_scale 1 >/dev/null 2>&1
   $ADB_COMMAND shell settings put global transition_animation_scale 1 >/dev/null 2>&1
   $ADB_COMMAND shell settings put global animator_duration_scale 1 >/dev/null 2>&1

    echo "🚀 Bắt đầu cài đặt Projectivy Launcher..."
    echo "Đang chạy p.apk ..." >/dev/null 2>&1
    install_apk "p.apk" >/dev/null 2>&1

    $ADB_COMMAND shell monkey -p com.spocky.projengmenu -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
    $ADB_COMMAND shell am start -n com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1
    $ADB_COMMAND shell cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1

    local apps="com.mitv.tvhome com.mitv.gallery com.xiaomi.tweather com.mitv.screensaver 
        com.xiaomi.mitv.shop com.duokan.videodaily com.xiaomi.tv.gallery 
        com.mitv.cloudcontrol com.miui.tv.analytics com.xiaomi.voicecontrol 
        com.xiaomi.mitv.upgrade com.xiaomi.mitv.appstore com.xiaomi.mitv.calendar 
        com.xiaomi.mitv.handbook com.xiaomi.screenrecorder com.sohu.inputmethod.sogou.tv 
        com.xiaomi.mitv.karaoke.service com.xiaomi.mitv.hyper.screensaver com.android.tv.settings"

    for app in $apps; do
        $ADB_COMMAND shell pm disable-user --user 0 "$app" >/dev/null 2>&1
    done

    local apks_to_install="mistore.apk keyboard.apk katniss_2.2.0.apk allapp.apk down.apk mitv.apk an.apk youtube.apk phim4k.apk getout.apk"

    echo "🚀 Bắt đầu cài đặt THÊM CÁC ỨNG DỤNG KHÁC..."
    for apk in $apks_to_install; do
        install_apk "$apk"
    done
    
    $ADB_COMMAND push 470.plbackup /sdcard/Download >/dev/null 2>&1

    copy_wallpapers
    # Cấp quyền nâng cao cho ứng dụng
    # Danh sách ứng dụng (cách nhau bằng dấu cách)
    local app_list="com.spocky.projengmenu"

    # Danh sách quyền AppOps và Runtime Perms
    local appops_perms="REQUEST_INSTALL_PACKAGES WRITE_SETTINGS MANAGE_EXTERNAL_STORAGE"
    local runtime_perms="android.permission.READ_EXTERNAL_STORAGE android.permission.WRITE_EXTERNAL_STORAGE android.permission.READ_MEDIA_IMAGES android.permission.READ_MEDIA_VIDEO android.permission.READ_MEDIA_AUDIO"

    echo -e "${YELLOW}🔑 ĐANG CẤP QUYỀN ỨNG DỤNG...${NC}"

    # Đếm tổng số lượng app trong danh sách chuẩn POSIX
    local total_apps=0
    for pkg in $app_list; do
        total_apps=$((total_apps + 1))
    done

    local i=0
    for pkg in $app_list; do
        i=$((i + 1))
        
        # 1. Tính toán hiển thị thanh tiến trình Progress Bar
        local percent=$(( (i * 100) / total_apps ))
        local num_blocks=$(( (20 * i) / total_apps ))
        local num_dashes=$(( 20 - num_blocks ))
        
        # Tạo chuỗi kí tự chạy hình khối █
        local bar=""
        local b=0
        while [ $b -lt $num_blocks ]; do
            bar="${bar}█"
            b=$((b + 1))
        done
        local d=0
        while [ $d -lt $num_dashes ]; do
            bar="${bar}-"
            d=$((d + 1))
        done

        # In tiến trình cập nhật liên tục trên một dòng (\r)
        printf "\r  [%s] %d%% | %bCấp quyền:%b %s" "$bar" "$percent" "${CYAN}" "${NC}" "$pkg"

        # 2. Cấp quyền đặc biệt qua AppOps
        for perm in $appops_perms; do
            $ADB_COMMAND shell appops set "$pkg" "$perm" allow >/dev/null 2>&1
        done

        # 3. Cấp quyền Runtime qua PM Grant
        for perm in $runtime_perms; do
            $ADB_COMMAND shell pm grant "$pkg" "$perm" >/dev/null 2>&1
        done

        # 4. Buộc dừng ứng dụng để hệ thống Android cập nhật quyền ngay lập tức
        $ADB_COMMAND shell am force-stop "$pkg" >/dev/null 2>&1
    done
    
    sleep 1
    # Dọn dẹp dòng ghi đè và báo thành công
    printf "\r%100s\r" " "
    echo -e "${GREEN}✅ Đã cấp quyền và đồng bộ hóa $total_apps ứng dụng!${NC}"

    echo -e "${CYAN}⚙️  THIẾT LẬP HỆ THỐNG NÂNG CAO (A14)...${NC}"

    # Định nghĩa chuỗi chứa các lệnh cấu hình đặc biệt cho TV (mỗi lệnh cách nhau bằng dấu sổ đứng |)
    local list_xs_a14="cmd package clear-app-profiles com.mitv.tvhome|\
     pm grant com.mitv.shareds android.permission.WRITE_SECURE_SETTINGS|\
     pm grant com.mitv.shareds android.permission.CHANGE_CONFIGURATION|\
     pm grant com.spocky.projengmenu android.permission.WRITE_EXTERNAL_STORAGE|\
     pm grant com.spocky.projengmenu android.permission.READ_EXTERNAL_STORAGE|\
     pm grant com.spocky.projengmenu android.permission.WRITE_SECURE_SETTINGS|\
     appops set com.google.android.katniss SYSTEM_ALERT_WINDOW allow|\
     cmd appops set com.spocky.projengmenu WRITE_EXTERNAL_STORAGE allow|\
     cmd appops set com.spocky.projengmenu READ_EXTERNAL_STORAGE allow|\
     appops set com.spocky.projengmenu REQUEST_INSTALL_PACKAGES allow|\
     ime enable com.liskovsoft.leankeyboard/.ime.LeanbackImeService|\
     settings put secure default_input_method com.liskovsoft.leankeyboard/.ime.LeanbackImeService|\
     settings put secure enabled_accessibility_services com.mitv.shareds/com.mitv.shareds.HomeService|\
     settings put secure accessibility_enabled 1|\
     cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity"

    # Đổi dấu phân tách vòng lặp mặc định (IFS) sang dấu sổ đứng | để đọc trọn vẹn cả câu lệnh có chứa dấu cách
    local OLD_IFS="$IFS"
    IFS="|"

    # Chạy vòng lặp duyệt qua từng lệnh và thực thi adb shell trên TV
    for cmd in $list_xs_a14; do
        # Tránh thực thi nếu dòng bị trống
        [ -z "$cmd" ] && continue
        
        # Gửi lệnh adb shell ẩn log ra màn hình
        $ADB_COMMAND shell "$cmd" >/dev/null 2>&1
    done

    # Trả lại cấu hình IFS mặc định cho hệ thống tránh lỗi các vòng lặp khác
    IFS="$OLD_IFS"
    # Xóa dòng trạng thái cũ bằng cách ghi đè 115 khoảng trắng và in thông báo hoàn tất
    printf "\r%115s\r" " "
    echo -e "${GREEN}✅ Đã hoàn tất toàn bộ cấu hình hệ thống nâng cao!${NC}"
    
    # CHÈN CÁC LỆNH KHÓA ĐUÔI VÀ TỐI ƯU RIÊNG PROJECTIVY LAUNCHER
    echo -e "\n${YELLOW}⚡ Đang tối ưu hóa riêng Projectivy Launcher...${NC}"

    # 1. Tối ưu hóa tốc độ khởi chạy riêng cho Projectivy
    $ADB_COMMAND shell cmd package compile -m speed -f com.spocky.projectivylauncher >/dev/null 2>&1

    # 2. Cấp quyền cài đặt ứng dụng từ nguồn ngoài
    $ADB_COMMAND shell settings put global install_non_market_apps 1 >/dev/null 2>&1

    echo -e "\n${YELLOW}🔄 Đang ghi dữ liệu bảo mật và đồng bộ ổ cứng TV...${NC}"
    
    # 4. Ép hệ thống flush dữ liệu từ RAM xuống file cấu hình vật lý
    $ADB_COMMAND shell settings list secure >/dev/null 2>&1
    $ADB_COMMAND shell sync >/dev/null 2>&1
    
    echo -e "${GREEN}✅ Cài đặt GIAO DIỆN Projectivy hoàn tất !${NC}"
    sleep 2
    echo "Đang gửi lệnh khởi động lại..."
    $ADB_COMMAND reboot >/dev/null 2>&1 &
    
    # Giải phóng tiến trình ngầm để tránh terminal bị treo đợi phản hồi từ TV
    PID=$!
    sleep 1
    kill $PID >/dev/null 2>&1
    
    echo -e "${GREEN}✅ Hoàn tất MENU 2!${NC}"
    menu1
}

# Sao chép ảnh nền vào TV
copy_wallpapers() {
    echo "🖼️ Bắt đầu tải ảnh lên TV của bạn..."
    local count=0
    
    for file in *; do
        [ -f "$file" ] || continue
        case "$file" in
            *.jpg|*.jpeg|*.png|*.JPG|*.JPEG|*.PNG)
                local extension="${file##*.}"
                echo "    -> Đang tải ảnh $file..."
                $ADB_COMMAND push "$file" "/sdcard/DCIM_${count}.${extension}" >/dev/null 2>&1
                count=$((count + 1))
                ;;
        esac
    done

    if [ "$count" -eq 0 ]; then
        echo -e "   ${YELLOW}⚠️ Không tìm thấy file ảnh nào.${NC}"
    else
        echo -e "${GREEN}✅ Đã tải $count ảnh vào thư mục /sdcard/DCIM/ trên TV.${NC}"
    fi
    sleep 3
}

# Cài đặt tất cả các file .apk trong thư mục nguồn
install_all_apks() {
    echo "🔧 Bắt đầu cài đặt tất cả các file .apk..."
    local count=0
    
    for file in *.apk; do
        if [ -f "$file" ]; then
            install_apk "$file"
            count=$((count + 1))
        fi
    done
    
    if [ "$count" -eq 0 ]; then
        echo -e "   ${YELLOW}⚠️ Không tìm thấy file .apk nào.${NC}"
        sleep 3
        return
    fi

    for cmd in \
        "settings put global stay_on_while_plugged_in 3" \
        "monkey -p com.spocky.projengmenu -c android.intent.category.LAUNCHER 1" \
        "am start -n com.spocky.projengmenu/.ui.home.MainActivity" \
        "cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity"
    do
        $ADB_COMMAND shell "$cmd" >/dev/null 2>&1
    done

    $ADB_COMMAND push 470.plbackup /sdcard/Download >/dev/null 2>&1

    echo -e "${GREEN}✅ Đã xử lý hoàn tất các file .apk.${NC}"
    sleep 3
    menu2
}

# Xin quyền mã tivi x s sau khi tắt voice
permission() {
    $ADB_COMMAND shell pm disable-user --user 0 com.xiaomi.voicecontrol >/dev/null 2>&1
    $ADB_COMMAND shell pm enable --user 0 com.xiaomi.mitv.settings >/dev/null 2>&1
    $ADB_COMMAND shell appops set com.xiaomi.voicecontrol SYSTEM_ALERT_WINDOW deny >/dev/null 2>&1
}

# Khởi động lại TV
reboot_tv() {
    local mode="$1"
    print_header
    echo "→ Reboot TV ($mode)"

    if [ "$mode" = "recovery" ]; then
        $ADB_COMMAND reboot recovery >/dev/null 2>&1 &
    else
        $ADB_COMMAND reboot >/dev/null 2>&1 &
    fi

    echo "→ Đã gửi lệnh reboot (không chờ phản hồi)"
    sleep 1

    echo "→ Ngắt kết nối ADB"
    $ADB_COMMAND disconnect >/dev/null 2>&1

    echo "→ Chờ TV khởi động lại..."
    sleep 8

    echo "→ Quay về Menu kết nối"
    sleep 1
    menu1
}

# =================== START ===================
menu1
            