import 'package:flutter/material.dart';

class LocationSettingScreen extends StatefulWidget {
  const LocationSettingScreen({super.key});

  @override
  State<LocationSettingScreen> createState() => _LocationSettingScreenState();
}

class _LocationSettingScreenState extends State<LocationSettingScreen> {
  String selectedLocation = '아라동';
  List<String> locations = ['아라동', '도두동', '이호동', '내도동', '외도동'];
  double rangeValue = 2;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final dividerColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
        ),
        title: Text('내 동네 설정', style: TextStyle(color: iconColor)),
        backgroundColor: cardColor,
        foregroundColor: iconColor,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildCurrentLocation(isDark, cardColor),
          Divider(height: 8, thickness: 8, color: dividerColor),
          _buildRangeSelector(isDark, cardColor),
          Divider(height: 8, thickness: 8, color: dividerColor),
          _buildLocationList(isDark, cardColor),
        ],
      ),
    );
  }

  Widget _buildCurrentLocation(bool isDark, Color cardColor) {
    final textColor = isDark ? Colors.white : Colors.black;
    return Container(
      padding: const EdgeInsets.all(16),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '현재 동네',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F0F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedLocation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _showAddLocationDialog(),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('동네 추가'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : Colors.black87,
                  side: BorderSide(
                    color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSelector(bool isDark, Color cardColor) {
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey[400] : Colors.grey[500];
    final infoBgColor = isDark ? Colors.grey[800] : Colors.grey[100];

    String getRangeText() {
      switch (rangeValue.toInt()) {
        case 1:
          return '내 동네';
        case 2:
          return '근처 동네';
        case 3:
          return '먼 동네';
        case 4:
          return '아주 먼 동네';
        default:
          return '근처 동네';
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '동네 범위',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F0F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  getRangeText(),
                  style: const TextStyle(
                    color: Color(0xFFFF6F0F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: rangeValue,
            min: 1,
            max: 4,
            divisions: 3,
            activeColor: const Color(0xFFFF6F0F),
            inactiveColor: isDark ? Colors.grey[700] : Colors.grey[300],
            onChanged: (value) {
              setState(() {
                rangeValue = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('좁게', style: TextStyle(fontSize: 12, color: hintColor)),
                Text('넓게', style: TextStyle(fontSize: 12, color: hintColor)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: infoBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: hintColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '선택한 범위의 동네 게시글만 볼 수 있어요',
                    style: TextStyle(fontSize: 13, color: hintColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationList(bool isDark, Color cardColor) {
    final textColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[300];

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '동네 목록',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: locations.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: dividerColor),
                itemBuilder: (context, index) {
                  final location = locations[index];
                  final isSelected = location == selectedLocation;

                  return ListTile(
                    title: Text(
                      location,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFFF6F0F) : textColor,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Color(0xFFFF6F0F))
                        : null,
                    onTap: () {
                      setState(() {
                        selectedLocation = location;
                      });
                      Navigator.pop(context, selectedLocation);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('동네 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('현재 위치를 기반으로 동네를 추가합니다.'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('위치 권한이 필요합니다')));
                },
                icon: const Icon(Icons.my_location),
                label: const Text('현재 위치로 설정'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F0F),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
