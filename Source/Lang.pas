{
  Localization unit.
  Contains strings on Russian and English and a function returning a string for current language.
}

unit Lang;

interface

uses Windows;

// String IDs
type
  TStringID =
  (
    idParamNone,
    idParamPresent,
    idFuncName,
    // messages
    idMsgNoParam,
    idMsgFnWasCalled,
    // other
    idBla
  );

procedure SetCurrLang(Lang: LANGID);
function LangString(StrId: TStringID): string;

implementation

type
  TLangStrings = array[TStringID] of string;

  TLangData = record
    LangId: LANGID;
    Strings: TLangStrings;
  end;

const
  LangData: array[1..2] of TLangData =
  (
    // en
    (
      LangId: LANG_ENGLISH;
      Strings: (
        'none',
        '"%s"',
        'Function %s::%s',
        // messages
        '%s. parameter expected',
        'Function %s was called, parameter: %s',
        // other
        'Blabla'
      );
    ),
    // ru
    (
      LangId: LANG_RUSSIAN;
      Strings: (
        'отсутствует',
        '"%s"',
        'Функция %s::%s',
        // messages
        '%s. не указан параметр',
        'Вызвана %s, параметр: %s',
        // other
        'Блабла'
      );
    )
  );

var
  CurrLangId: LANGID = LANG_NEUTRAL;

procedure SetCurrLang(Lang: LANGID);
begin
  CurrLangId := Lang;
end;

// Returns a string with given ID corresponding to current langID
function LangString(StrId: TStringID): string;
var i: Integer;
begin
  for i := Low(LangData) to High(LangData) do
    if LangData[i].LangId = CurrLangId then
      Exit(LangData[i].Strings[StrId]);
  // lang ID not found - switch to English and re-run
  CurrLangId := LANG_ENGLISH;
  Result := LangString(StrId);
end;


end.
