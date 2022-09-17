&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Рек_НомерПорта = Константы.НомерКомПорта.Получить();
КонецПроцедуры

&НаСервере
Процедура Рек_НомерПортаПриИзменении(Элемент)
	Константы.НомерКомПорта.Установить(Рек_НомерПорта);
КонецПроцедуры

&НаКлиенте
Процедура КомандаПортОткрыть(Команда)
    ОткрытьПорт(Рек_НомерПорта);
    
    Если КомПорт.PortOpen Тогда 
    	ДобавитьОбработчик КомПорт.OnComm, ПолученыДанные;
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура КомандаСвязьПроверка(Команда)
	СвязьПроверка();
КонецПроцедуры

&НаКлиенте
Процедура КомандаИзмерениеЗапрос(Команда)
	ИзмерениеЗапрос();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	УдалитьОбработчик КомПорт.OnComm, ПолученыДанные;
	ЗакрытьПорт();
КонецПроцедуры

&НаКлиенте
Процедура ПолученыДанные()
	
	ComSafeArray = КомПорт.input;
	
	Если (ComSafeArray.GetDimensions() <> 1) Тогда
		Сообщить("ОШИБКА: неверное число измерений COM массива");
		Возврат;
	КонецЕсли;
	
	Если (ComSafeArray.GetLength() = 0) Тогда
		Если КомПорт.DsrHolding Тогда
			Сообщить("Собеседник подключен");
			Возврат;
		Иначе
			Сообщить("Собеседник отключен");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если (ComSafeArray.GetLength() <> ДлинаМасДанных) Тогда
		Сообщить("ОШИБКА: неверная длина COM массива: "+
		ComSafeArray.GetLength() );
		Возврат;
	КонецЕсли;
	//
	ИндМин = ComSafeArray.GetLowerBound(0);
    ИндМакс = ComSafeArray.GetUpperBound(0);	
	РеквТекст = "";
	
	Если ( ComSafeArray.GetValue(ИндМакс) <> КонтрСумма(ComSafeArray) ) Тогда
		Сообщить("ОШИБКА: неверная контрольная сумма: расчитано " + КонтрСумма(ComSafeArray) + ", " +
		+ " получено " + ComSafeArray.GetValue(ИндМакс)
		);
		Возврат;
	КонецЕсли; 

	//
	Если ComSafeArray.GetValue(ИндМин)=202 Тогда//CA
		РеквТекст = "Собеседник на свзяи";
		
				
	ИначеЕсли ComSafeArray.GetValue(ИндМин)=221 Тогда//DD
		РеквТекст = "Собеседник прислал данные";
		Для Инд = ИндМин+1 по ИндМакс-1 Цикл
			ЭлементМассива = ComSafeArray.GetValue(Инд);
			РеквТекст = РеквТекст + " | " + ЭлементМассива;
		КонецЦикла;
		
	ИначеЕсли ComSafeArray.GetValue(ИндМин)=204 Тогда//CС
		РеквТекст = "Собеседник желает проверить связь";
        ОтправитьКоманду( КмдШаблон_СвязьПодтвердить_СА_новая() );	
		
	КонецЕсли;
	
	Сообщить(РеквТекст);
			
КонецПроцедуры


