import 'package:flutter/material.dart';
import 'order_food_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedYear = DateTime.now().year;
  String _selectedMonth = 'Jan';
  int _selectedDay = 1;
  final TextEditingController _budgetController = TextEditingController();

  final Map<String, int> _monthDays = {
    'Jan': 31,
    'Feb': 28,
    'Mar': 31,
    'Apr': 30,
    'May': 31,
    'Jun': 30,
    'Jul': 31,
    'Aug': 31,
    'Sep': 30,
    'Oct': 31,
    'Nov': 30,
    'Dec': 31,
  };

  @override
  void initState() {
    super.initState();
    updateDaysInMonth();
  }

  void updateDaysInMonth() {
    setState(() {
      // Adjust for leap year
      if (_selectedMonth == 'Feb' &&
          (_selectedYear % 4 == 0 &&
              (_selectedYear % 100 != 0 || _selectedYear % 400 == 0))) {
        _monthDays['Feb'] = 29;
      } else {
        _monthDays['Feb'] = 28;
      }
      if (_selectedDay > _monthDays[_selectedMonth]!) {
        _selectedDay = _monthDays[_selectedMonth]!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedMonth,
                    items: _monthDays.keys
                        .map((month) =>
                            DropdownMenuItem(value: month, child: Text(month)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value!;
                        updateDaysInMonth();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _selectedDay,
                    items: List.generate(
                      _monthDays[_selectedMonth]!,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedDay = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _selectedYear,
                    items: List.generate(
                      5,
                      (index) => DropdownMenuItem(
                        value: DateTime.now().year + index,
                        child: Text('${DateTime.now().year + index}'),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value!;
                        updateDaysInMonth();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Budget',
                prefixText: '\$',
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_budgetController.text.isEmpty) return;
                final selectedDate = DateTime(
                  _selectedYear,
                  _monthDays.keys.toList().indexOf(_selectedMonth) + 1,
                  _selectedDay,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderFoodScreen(
                      budget: double.parse(_budgetController.text),
                    ),
                  ),
                );
              },
              child: const Text('Select Food'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedYear = DateTime.now().year;
                  _selectedMonth = 'Jan';
                  _selectedDay = 1;
                  _budgetController.clear();
                });
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
