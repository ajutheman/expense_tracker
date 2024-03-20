// hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense.dart';

class HiveService {
  static const String _expenseBoxName = 'expenses';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseAdapter());
  }

  static Future<Box<Expense>> openExpenseBox() async {
    return await Hive.openBox<Expense>(_expenseBoxName);
  }
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    return Expense(
      id: reader.readString(),
      title: reader.readString(),
      amount: reader.readDouble(),
      date: DateTime.parse(reader.readString() ?? ''),
      category: Category.values[reader.readInt()],
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeDouble(obj.amount);
    writer.writeString(obj.date.toIso8601String());
    writer.writeInt(obj.category.index);
  }
}
