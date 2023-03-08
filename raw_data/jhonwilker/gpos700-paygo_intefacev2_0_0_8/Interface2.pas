
unit Interface2;

interface

uses
  Androidapi.JNIBridge,
  Androidapi.JNI.App,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
  Androidapi.JNI.Util;

type
// ===== Forward declarations =====

  JAnimator = interface;//android.animation.Animator
  JAnimator_AnimatorListener = interface;//android.animation.Animator$AnimatorListener
  JAnimator_AnimatorPauseListener = interface;//android.animation.Animator$AnimatorPauseListener
  JKeyframe = interface;//android.animation.Keyframe
  JLayoutTransition = interface;//android.animation.LayoutTransition
  JLayoutTransition_TransitionListener = interface;//android.animation.LayoutTransition$TransitionListener
  JPropertyValuesHolder = interface;//android.animation.PropertyValuesHolder
  JStateListAnimator = interface;//android.animation.StateListAnimator
  JTimeInterpolator = interface;//android.animation.TimeInterpolator
  JTypeConverter = interface;//android.animation.TypeConverter
  JTypeEvaluator = interface;//android.animation.TypeEvaluator
  JValueAnimator = interface;//android.animation.ValueAnimator
  JValueAnimator_AnimatorUpdateListener = interface;//android.animation.ValueAnimator$AnimatorUpdateListener
  JPathMotion = interface;//android.transition.PathMotion
  JScene = interface;//android.transition.Scene
  JTransition = interface;//android.transition.Transition
  JTransition_EpicenterCallback = interface;//android.transition.Transition$EpicenterCallback
  JTransition_TransitionListener = interface;//android.transition.Transition$TransitionListener
  JTransitionManager = interface;//android.transition.TransitionManager
  JTransitionPropagation = interface;//android.transition.TransitionPropagation
  JTransitionValues = interface;//android.transition.TransitionValues
  JInterpolator = interface;//android.view.animation.Interpolator
  JToolbar_LayoutParams = interface;//android.widget.Toolbar$LayoutParams
  JAplicacaoNaoInstaladaExcecao = interface;//br.com.setis.interfaceautomacao.AplicacaoNaoInstaladaExcecao
  Jinterfaceautomacao_BuildConfig = interface;//br.com.setis.interfaceautomacao.BuildConfig
  JCartoes = interface;//br.com.setis.interfaceautomacao.Cartoes
  JComunicacaoServico = interface;//br.com.setis.interfaceautomacao.ComunicacaoServico
  JComunicacaoServico_IncomingHandler = interface;//br.com.setis.interfaceautomacao.ComunicacaoServico$IncomingHandler
  JConfirmacao = interface;//br.com.setis.interfaceautomacao.Confirmacao
  JConfirmacoes = interface;//br.com.setis.interfaceautomacao.Confirmacoes
  JDadosAutomacao = interface;//br.com.setis.interfaceautomacao.DadosAutomacao
  JEntradaTransacao = interface;//br.com.setis.interfaceautomacao.EntradaTransacao
  JFinanciamentos = interface;//br.com.setis.interfaceautomacao.Financiamentos
  JGlobalDefs = interface;//br.com.setis.interfaceautomacao.GlobalDefs
  JIdentificacaoPortadorCarteira = interface;//br.com.setis.interfaceautomacao.IdentificacaoPortadorCarteira
  JModalidadesPagamento = interface;//br.com.setis.interfaceautomacao.ModalidadesPagamento
  JModalidadesTransacao = interface;//br.com.setis.interfaceautomacao.ModalidadesTransacao
  JOperacoes = interface;//br.com.setis.interfaceautomacao.Operacoes
  JPersonalizacao = interface;//br.com.setis.interfaceautomacao.Personalizacao
  JPersonalizacao_1 = interface;//br.com.setis.interfaceautomacao.Personalizacao$1
  JPersonalizacao_Builder = interface;//br.com.setis.interfaceautomacao.Personalizacao$Builder
  JProvedores = interface;//br.com.setis.interfaceautomacao.Provedores
  JQuedaConexaoTerminalExcecao = interface;//br.com.setis.interfaceautomacao.QuedaConexaoTerminalExcecao
  JSaidaTransacao = interface;//br.com.setis.interfaceautomacao.SaidaTransacao
  JSenderActivity = interface;//br.com.setis.interfaceautomacao.SenderActivity
  JStatusTransacao = interface;//br.com.setis.interfaceautomacao.StatusTransacao
  JTerminal = interface;//br.com.setis.interfaceautomacao.Terminal
  JTerminalDesconectadoExcecao = interface;//br.com.setis.interfaceautomacao.TerminalDesconectadoExcecao
  JTerminalNaoConfiguradoExcecao = interface;//br.com.setis.interfaceautomacao.TerminalNaoConfiguradoExcecao
  JTransacao = interface;//br.com.setis.interfaceautomacao.Transacao
  JTransacaoPendenteDados = interface;//br.com.setis.interfaceautomacao.TransacaoPendenteDados
  JTransacoes = interface;//br.com.setis.interfaceautomacao.Transacoes
  JTransacoes_1 = interface;//br.com.setis.interfaceautomacao.Transacoes$1
  JTransacoes_TransacaoResultReceiver = interface;//br.com.setis.interfaceautomacao.Transacoes$TransacaoResultReceiver
  JVersoes = interface;//br.com.setis.interfaceautomacao.Versoes
  JViasImpressao = interface;//br.com.setis.interfaceautomacao.ViasImpressao
  JCustomization = interface;//br.com.setis.interfaceautomacao.espec.Customization
  JTransactionInput = interface;//br.com.setis.interfaceautomacao.espec.TransactionInput
  JTransactionOutput = interface;//br.com.setis.interfaceautomacao.espec.TransactionOutput
  JDateParser = interface;//br.com.setis.interfaceautomacao.parser.DateParser
  JEnumType = interface;//br.com.setis.interfaceautomacao.parser.EnumType
  JInputParser = interface;//br.com.setis.interfaceautomacao.parser.InputParser
  JOutputParser = interface;//br.com.setis.interfaceautomacao.parser.OutputParser
  Jparser_ParseException = interface;//br.com.setis.interfaceautomacao.parser.ParseException
  JUriArrayFieldName = interface;//br.com.setis.interfaceautomacao.parser.UriArrayFieldName
  Jparser_UriClass = interface;//br.com.setis.interfaceautomacao.parser.UriClass
  JUriCustomizeFieldName = interface;//br.com.setis.interfaceautomacao.parser.UriCustomizeFieldName
  JUriDateFieldName = interface;//br.com.setis.interfaceautomacao.parser.UriDateFieldName
  JUriEnumFieldName = interface;//br.com.setis.interfaceautomacao.parser.UriEnumFieldName
  JUriFileFieldName = interface;//br.com.setis.interfaceautomacao.parser.UriFileFieldName
  JUriMethodName = interface;//br.com.setis.interfaceautomacao.parser.UriMethodName
  JUriObjectFieldName = interface;//br.com.setis.interfaceautomacao.parser.UriObjectFieldName
  JUriPrimitiveFieldName = interface;//br.com.setis.interfaceautomacao.parser.UriPrimitiveFieldName

// ===== Interface declarations =====

  JAnimatorClass = interface(JObjectClass)
    ['{3F76A5DF-389E-4BD3-9861-04C5B00CEADE}']
    {class} function init: JAnimator; cdecl;//Deprecated
    {class} procedure addListener(listener: JAnimator_AnimatorListener); cdecl;//Deprecated
    {class} procedure addPauseListener(listener: JAnimator_AnimatorPauseListener); cdecl;//Deprecated
    {class} function getDuration: Int64; cdecl;
    {class} function getInterpolator: JTimeInterpolator; cdecl;
    {class} function getListeners: JArrayList; cdecl;
    {class} function isStarted: Boolean; cdecl;
    {class} procedure pause; cdecl;
    {class} procedure removeAllListeners; cdecl;
    {class} procedure resume; cdecl;
    {class} function setDuration(duration: Int64): JAnimator; cdecl;
    {class} procedure setInterpolator(value: JTimeInterpolator); cdecl;
    {class} procedure setupStartValues; cdecl;
    {class} procedure start; cdecl;
  end;

  [JavaSignature('android/animation/Animator')]
  JAnimator = interface(JObject)
    ['{FA13E56D-1B6D-4A3D-8327-9E5BA785CF21}']
    procedure cancel; cdecl;
    function clone: JAnimator; cdecl;
    procedure &end; cdecl;
    function getStartDelay: Int64; cdecl;
    function isPaused: Boolean; cdecl;
    function isRunning: Boolean; cdecl;
    procedure removeListener(listener: JAnimator_AnimatorListener); cdecl;
    procedure removePauseListener(listener: JAnimator_AnimatorPauseListener); cdecl;
    procedure setStartDelay(startDelay: Int64); cdecl;
    procedure setTarget(target: JObject); cdecl;
    procedure setupEndValues; cdecl;
  end;
  TJAnimator = class(TJavaGenericImport<JAnimatorClass, JAnimator>) end;

  JAnimator_AnimatorListenerClass = interface(IJavaClass)
    ['{5ED6075A-B997-469C-B8D9-0AA8FB7E4798}']
    {class} procedure onAnimationCancel(animation: JAnimator); cdecl;//Deprecated
    {class} procedure onAnimationEnd(animation: JAnimator); cdecl;//Deprecated
    {class} procedure onAnimationRepeat(animation: JAnimator); cdecl;//Deprecated
  end;

  [JavaSignature('android/animation/Animator$AnimatorListener')]
  JAnimator_AnimatorListener = interface(IJavaInstance)
    ['{E2DE8DD6-628B-4D84-AA46-8A1E3F00FF13}']
    procedure onAnimationStart(animation: JAnimator); cdecl;//Deprecated
  end;
  TJAnimator_AnimatorListener = class(TJavaGenericImport<JAnimator_AnimatorListenerClass, JAnimator_AnimatorListener>) end;

  JAnimator_AnimatorPauseListenerClass = interface(IJavaClass)
    ['{CB0DC3F0-63BC-4284-ADD0-2ED367AE11E5}']
    {class} procedure onAnimationPause(animation: JAnimator); cdecl;//Deprecated
  end;

  [JavaSignature('android/animation/Animator$AnimatorPauseListener')]
  JAnimator_AnimatorPauseListener = interface(IJavaInstance)
    ['{43C9C106-65EA-4A7D-A958-FAB9E43FA4A6}']
    procedure onAnimationResume(animation: JAnimator); cdecl;//Deprecated
  end;
  TJAnimator_AnimatorPauseListener = class(TJavaGenericImport<JAnimator_AnimatorPauseListenerClass, JAnimator_AnimatorPauseListener>) end;

  JKeyframeClass = interface(JObjectClass)
    ['{D383116E-5CCF-48D8-9EA1-B26FBF24BA39}']
    {class} function init: JKeyframe; cdecl;//Deprecated
    {class} function clone: JKeyframe; cdecl;
    {class} function getFraction: Single; cdecl;
    {class} function hasValue: Boolean; cdecl;
    {class} function ofFloat(fraction: Single; value: Single): JKeyframe; cdecl; overload;
    {class} function ofFloat(fraction: Single): JKeyframe; cdecl; overload;
    {class} function ofInt(fraction: Single; value: Integer): JKeyframe; cdecl; overload;//Deprecated
    {class} function ofInt(fraction: Single): JKeyframe; cdecl; overload;//Deprecated
    {class} function ofObject(fraction: Single; value: JObject): JKeyframe; cdecl; overload;//Deprecated
    {class} function ofObject(fraction: Single): JKeyframe; cdecl; overload;//Deprecated
    {class} procedure setFraction(fraction: Single); cdecl;//Deprecated
    {class} procedure setInterpolator(interpolator: JTimeInterpolator); cdecl;//Deprecated
  end;

  [JavaSignature('android/animation/Keyframe')]
  JKeyframe = interface(JObject)
    ['{9D0687A4-669E-440F-8290-154739405019}']
    function getInterpolator: JTimeInterpolator; cdecl;
    function getType: Jlang_Class; cdecl;
    function getValue: JObject; cdecl;
    procedure setValue(value: JObject); cdecl;//Deprecated
  end;
  TJKeyframe = class(TJavaGenericImport<JKeyframeClass, JKeyframe>) end;

  JLayoutTransitionClass = interface(JObjectClass)
    ['{433C5359-0A96-4796-AD7B-8084EF7EF7C4}']
    {class} function _GetAPPEARING: Integer; cdecl;
    {class} function _GetCHANGE_APPEARING: Integer; cdecl;
    {class} function _GetCHANGE_DISAPPEARING: Integer; cdecl;
    {class} function _GetCHANGING: Integer; cdecl;
    {class} function _GetDISAPPEARING: Integer; cdecl;
    {class} function init: JLayoutTransition; cdecl;//Deprecated
    {class} procedure disableTransitionType(transitionType: Integer); cdecl;//Deprecated
    {class} procedure enableTransitionType(transitionType: Integer); cdecl;//Deprecated
    {class} function getAnimator(transitionType: Integer): JAnimator; cdecl;//Deprecated
    {class} function getStartDelay(transitionType: Integer): Int64; cdecl;
    {class} function getTransitionListeners: JList; cdecl;
    {class} procedure hideChild(parent: JViewGroup; child: JView); cdecl; overload;//Deprecated
    {class} function isTransitionTypeEnabled(transitionType: Integer): Boolean; cdecl;
    {class} procedure removeChild(parent: JViewGroup; child: JView); cdecl;
    {class} procedure removeTransitionListener(listener: JLayoutTransition_TransitionListener); cdecl;
    {class} procedure setDuration(transitionType: Integer; duration: Int64); cdecl; overload;
    {class} procedure setInterpolator(transitionType: Integer; interpolator: JTimeInterpolator); cdecl;
    {class} procedure setStagger(transitionType: Integer; duration: Int64); cdecl;
    {class} procedure showChild(parent: JViewGroup; child: JView; oldVisibility: Integer); cdecl; overload;
    {class} property APPEARING: Integer read _GetAPPEARING;
    {class} property CHANGE_APPEARING: Integer read _GetCHANGE_APPEARING;
    {class} property CHANGE_DISAPPEARING: Integer read _GetCHANGE_DISAPPEARING;
    {class} property CHANGING: Integer read _GetCHANGING;
    {class} property DISAPPEARING: Integer read _GetDISAPPEARING;
  end;

  [JavaSignature('android/animation/LayoutTransition')]
  JLayoutTransition = interface(JObject)
    ['{42450BEE-EBF2-4954-B9B7-F8DAE7DF0EC1}']
    procedure addChild(parent: JViewGroup; child: JView); cdecl;//Deprecated
    procedure addTransitionListener(listener: JLayoutTransition_TransitionListener); cdecl;//Deprecated
    function getDuration(transitionType: Integer): Int64; cdecl;
    function getInterpolator(transitionType: Integer): JTimeInterpolator; cdecl;
    function getStagger(transitionType: Integer): Int64; cdecl;
    procedure hideChild(parent: JViewGroup; child: JView; newVisibility: Integer); cdecl; overload;
    function isChangingLayout: Boolean; cdecl;
    function isRunning: Boolean; cdecl;
    procedure setAnimateParentHierarchy(animateParentHierarchy: Boolean); cdecl;
    procedure setAnimator(transitionType: Integer; animator: JAnimator); cdecl;
    procedure setDuration(duration: Int64); cdecl; overload;
    procedure setStartDelay(transitionType: Integer; delay: Int64); cdecl;
    procedure showChild(parent: JViewGroup; child: JView); cdecl; overload;//Deprecated
  end;
  TJLayoutTransition = class(TJavaGenericImport<JLayoutTransitionClass, JLayoutTransition>) end;

  JLayoutTransition_TransitionListenerClass = interface(IJavaClass)
    ['{9FA6F1EC-8EDB-4A05-AF58-B55A525AE114}']
  end;

  [JavaSignature('android/animation/LayoutTransition$TransitionListener')]
  JLayoutTransition_TransitionListener = interface(IJavaInstance)
    ['{0FBE048F-FCDA-4692-B6F1-DE0F07FAE885}']
    procedure endTransition(transition: JLayoutTransition; container: JViewGroup; view: JView; transitionType: Integer); cdecl;
    procedure startTransition(transition: JLayoutTransition; container: JViewGroup; view: JView; transitionType: Integer); cdecl;
  end;
  TJLayoutTransition_TransitionListener = class(TJavaGenericImport<JLayoutTransition_TransitionListenerClass, JLayoutTransition_TransitionListener>) end;

  JPropertyValuesHolderClass = interface(JObjectClass)
    ['{36C77AFF-9C3F-42B6-88F3-320FE8CF9B25}']
    {class} function ofMultiFloat(propertyName: JString; values: TJavaBiArray<Single>): JPropertyValuesHolder; cdecl; overload;
    {class} function ofMultiFloat(propertyName: JString; path: JPath): JPropertyValuesHolder; cdecl; overload;
    {class} function ofMultiInt(propertyName: JString; values: TJavaBiArray<Integer>): JPropertyValuesHolder; cdecl; overload;
    {class} function ofMultiInt(propertyName: JString; path: JPath): JPropertyValuesHolder; cdecl; overload;
    {class} function ofObject(propertyName: JString; converter: JTypeConverter; path: JPath): JPropertyValuesHolder; cdecl; overload;
    {class} function ofObject(property_: JProperty; converter: JTypeConverter; path: JPath): JPropertyValuesHolder; cdecl; overload;
    {class} procedure setConverter(converter: JTypeConverter); cdecl;
    {class} procedure setProperty(property_: JProperty); cdecl;//Deprecated
  end;

  [JavaSignature('android/animation/PropertyValuesHolder')]
  JPropertyValuesHolder = interface(JObject)
    ['{12B4ABFD-CBCA-4636-AF2D-C386EF895DC3}']
    function clone: JPropertyValuesHolder; cdecl;
    function getPropertyName: JString; cdecl;
    procedure setEvaluator(evaluator: JTypeEvaluator); cdecl;//Deprecated
    procedure setPropertyName(propertyName: JString); cdecl;//Deprecated
    function toString: JString; cdecl;//Deprecated
  end;
  TJPropertyValuesHolder = class(TJavaGenericImport<JPropertyValuesHolderClass, JPropertyValuesHolder>) end;

  JStateListAnimatorClass = interface(JObjectClass)
    ['{109E4067-E218-47B1-93EB-65B8916A98D8}']
    {class} function init: JStateListAnimator; cdecl;//Deprecated
    {class} procedure addState(specs: TJavaArray<Integer>; animator: JAnimator); cdecl;//Deprecated
    {class} function clone: JStateListAnimator; cdecl;//Deprecated
    {class} procedure jumpToCurrentState; cdecl;//Deprecated
  end;

  [JavaSignature('android/animation/StateListAnimator')]
  JStateListAnimator = interface(JObject)
    ['{CA2A9587-26AA-4DC2-8DFF-A1305A37608F}']
  end;
  TJStateListAnimator = class(TJavaGenericImport<JStateListAnimatorClass, JStateListAnimator>) end;

  JTimeInterpolatorClass = interface(IJavaClass)
    ['{1E682A1C-9102-461D-A3CA-5596683F1D66}']
  end;

  [JavaSignature('android/animation/TimeInterpolator')]
  JTimeInterpolator = interface(IJavaInstance)
    ['{639F8A83-7D9B-49AF-A19E-96B27E46D2AB}']
    function getInterpolation(input: Single): Single; cdecl;
  end;
  TJTimeInterpolator = class(TJavaGenericImport<JTimeInterpolatorClass, JTimeInterpolator>) end;

  JTypeConverterClass = interface(JObjectClass)
    ['{BE2DD177-6D79-4B0C-B4F5-4E4CD9D7436D}']
    {class} function init(fromClass: Jlang_Class; toClass: Jlang_Class): JTypeConverter; cdecl;//Deprecated
    {class} function convert(value: JObject): JObject; cdecl;
  end;

  [JavaSignature('android/animation/TypeConverter')]
  JTypeConverter = interface(JObject)
    ['{BFEA4116-0766-4AD9-AA8F-4C15A583EB2E}']
  end;
  TJTypeConverter = class(TJavaGenericImport<JTypeConverterClass, JTypeConverter>) end;

  JTypeEvaluatorClass = interface(IJavaClass)
    ['{15B67CAF-6F50-4AA3-A88F-C5AF78D62FD4}']
  end;

  [JavaSignature('android/animation/TypeEvaluator')]
  JTypeEvaluator = interface(IJavaInstance)
    ['{F436383D-6F44-40D8-ACDD-9057777691FC}']
    function evaluate(fraction: Single; startValue: JObject; endValue: JObject): JObject; cdecl;
  end;
  TJTypeEvaluator = class(TJavaGenericImport<JTypeEvaluatorClass, JTypeEvaluator>) end;

  JValueAnimatorClass = interface(JAnimatorClass)
    ['{FF3B71ED-5A33-45B0-8500-7672B0B98E2C}']
    {class} function _GetINFINITE: Integer; cdecl;
    {class} function _GetRESTART: Integer; cdecl;
    {class} function _GetREVERSE: Integer; cdecl;
    {class} function init: JValueAnimator; cdecl;//Deprecated
    {class} function clone: JValueAnimator; cdecl;
    {class} procedure &end; cdecl;
    {class} function getCurrentPlayTime: Int64; cdecl;//Deprecated
    {class} function getDuration: Int64; cdecl;//Deprecated
    {class} function getFrameDelay: Int64; cdecl;//Deprecated
    {class} function getStartDelay: Int64; cdecl;//Deprecated
    {class} function getValues: TJavaObjectArray<JPropertyValuesHolder>; cdecl;//Deprecated
    {class} function isRunning: Boolean; cdecl;//Deprecated
    {class} procedure resume; cdecl;//Deprecated
    {class} procedure reverse; cdecl;//Deprecated
    {class} procedure setCurrentFraction(fraction: Single); cdecl;//Deprecated
    {class} procedure setFrameDelay(frameDelay: Int64); cdecl;
    {class} procedure setRepeatCount(value: Integer); cdecl;
    {class} procedure setRepeatMode(value: Integer); cdecl;
    {class} procedure setStartDelay(startDelay: Int64); cdecl;
    {class} property INFINITE: Integer read _GetINFINITE;
    {class} property RESTART: Integer read _GetRESTART;
    {class} property REVERSE: Integer read _GetREVERSE;
  end;

  [JavaSignature('android/animation/ValueAnimator')]
  JValueAnimator = interface(JAnimator)
    ['{70F92B14-EFD4-4DC7-91DE-6617417AE194}']
    procedure addUpdateListener(listener: JValueAnimator_AnimatorUpdateListener); cdecl;
    procedure cancel; cdecl;
    function getAnimatedFraction: Single; cdecl;//Deprecated
    function getAnimatedValue: JObject; cdecl; overload;//Deprecated
    function getAnimatedValue(propertyName: JString): JObject; cdecl; overload;//Deprecated
    function getInterpolator: JTimeInterpolator; cdecl;//Deprecated
    function getRepeatCount: Integer; cdecl;//Deprecated
    function getRepeatMode: Integer; cdecl;//Deprecated
    function isStarted: Boolean; cdecl;//Deprecated
    procedure pause; cdecl;//Deprecated
    procedure removeAllUpdateListeners; cdecl;//Deprecated
    procedure removeUpdateListener(listener: JValueAnimator_AnimatorUpdateListener); cdecl;//Deprecated
    procedure setCurrentPlayTime(playTime: Int64); cdecl;
    function setDuration(duration: Int64): JValueAnimator; cdecl;
    procedure setEvaluator(value: JTypeEvaluator); cdecl;
    procedure setInterpolator(value: JTimeInterpolator); cdecl;
    procedure start; cdecl;
    function toString: JString; cdecl;
  end;
  TJValueAnimator = class(TJavaGenericImport<JValueAnimatorClass, JValueAnimator>) end;

  JValueAnimator_AnimatorUpdateListenerClass = interface(IJavaClass)
    ['{9CA50CBF-4462-4445-82CD-13CE985E2DE4}']
  end;

  [JavaSignature('android/animation/ValueAnimator$AnimatorUpdateListener')]
  JValueAnimator_AnimatorUpdateListener = interface(IJavaInstance)
    ['{0F883491-52EF-4A40-B7D2-FC23E11E46FE}']
    procedure onAnimationUpdate(animation: JValueAnimator); cdecl;//Deprecated
  end;
  TJValueAnimator_AnimatorUpdateListener = class(TJavaGenericImport<JValueAnimator_AnimatorUpdateListenerClass, JValueAnimator_AnimatorUpdateListener>) end;

  JPathMotionClass = interface(JObjectClass)
    ['{E1CD1A94-115C-492C-A490-37F0E72956EB}']
    {class} function init: JPathMotion; cdecl; overload;//Deprecated
    {class} function init(context: JContext; attrs: JAttributeSet): JPathMotion; cdecl; overload;//Deprecated
  end;

  [JavaSignature('android/transition/PathMotion')]
  JPathMotion = interface(JObject)
    ['{BDC08353-C9FB-42D7-97CC-C35837D2F536}']
    function getPath(startX: Single; startY: Single; endX: Single; endY: Single): JPath; cdecl;//Deprecated
  end;
  TJPathMotion = class(TJavaGenericImport<JPathMotionClass, JPathMotion>) end;

  JSceneClass = interface(JObjectClass)
    ['{8B9120CA-AEEA-4DE3-BDC9-15CFD23A7B07}']
    {class} function init(sceneRoot: JViewGroup): JScene; cdecl; overload;//Deprecated
    {class} function init(sceneRoot: JViewGroup; layout: JView): JScene; cdecl; overload;//Deprecated
    {class} function init(sceneRoot: JViewGroup; layout: JViewGroup): JScene; cdecl; overload;//Deprecated
    {class} procedure exit; cdecl;
    {class} function getSceneForLayout(sceneRoot: JViewGroup; layoutId: Integer; context: JContext): JScene; cdecl;
    {class} function getSceneRoot: JViewGroup; cdecl;
  end;

  [JavaSignature('android/transition/Scene')]
  JScene = interface(JObject)
    ['{85A60B99-5837-4F1F-A344-C627DD586B82}']
    procedure enter; cdecl;
    procedure setEnterAction(action: JRunnable); cdecl;
    procedure setExitAction(action: JRunnable); cdecl;
  end;
  TJScene = class(TJavaGenericImport<JSceneClass, JScene>) end;

  JTransitionClass = interface(JObjectClass)
    ['{60EC06BC-8F7A-4416-A04B-5B57987EB18E}']
    {class} function _GetMATCH_ID: Integer; cdecl;
    {class} function _GetMATCH_INSTANCE: Integer; cdecl;
    {class} function _GetMATCH_ITEM_ID: Integer; cdecl;
    {class} function _GetMATCH_NAME: Integer; cdecl;
    {class} function init: JTransition; cdecl; overload;//Deprecated
    {class} function init(context: JContext; attrs: JAttributeSet): JTransition; cdecl; overload;//Deprecated
    {class} function addListener(listener: JTransition_TransitionListener): JTransition; cdecl;
    {class} function addTarget(targetId: Integer): JTransition; cdecl; overload;
    {class} function canRemoveViews: Boolean; cdecl;//Deprecated
    {class} procedure captureEndValues(transitionValues: JTransitionValues); cdecl;//Deprecated
    {class} procedure captureStartValues(transitionValues: JTransitionValues); cdecl;//Deprecated
    {class} function excludeChildren(target: JView; exclude: Boolean): JTransition; cdecl; overload;//Deprecated
    {class} function excludeChildren(type_: Jlang_Class; exclude: Boolean): JTransition; cdecl; overload;//Deprecated
    {class} function excludeTarget(targetId: Integer; exclude: Boolean): JTransition; cdecl; overload;//Deprecated
    {class} function getDuration: Int64; cdecl;//Deprecated
    {class} function getEpicenter: JRect; cdecl;//Deprecated
    {class} function getEpicenterCallback: JTransition_EpicenterCallback; cdecl;//Deprecated
    {class} function getPropagation: JTransitionPropagation; cdecl;//Deprecated
    {class} function getStartDelay: Int64; cdecl;//Deprecated
    {class} function getTargetIds: JList; cdecl;//Deprecated
    {class} function getTargets: JList; cdecl;
    {class} function getTransitionProperties: TJavaObjectArray<JString>; cdecl;
    {class} function getTransitionValues(view: JView; start: Boolean): JTransitionValues; cdecl;
    {class} function removeTarget(targetName: JString): JTransition; cdecl; overload;
    {class} function removeTarget(target: JView): JTransition; cdecl; overload;
    {class} function removeTarget(target: Jlang_Class): JTransition; cdecl; overload;
    {class} procedure setPathMotion(pathMotion: JPathMotion); cdecl;
    {class} procedure setPropagation(transitionPropagation: JTransitionPropagation); cdecl;
    {class} property MATCH_ID: Integer read _GetMATCH_ID;
    {class} property MATCH_INSTANCE: Integer read _GetMATCH_INSTANCE;
    {class} property MATCH_ITEM_ID: Integer read _GetMATCH_ITEM_ID;
    {class} property MATCH_NAME: Integer read _GetMATCH_NAME;
  end;

  [JavaSignature('android/transition/Transition')]
  JTransition = interface(JObject)
    ['{C2F8200F-1C83-40AE-8C5B-C0C8BFF17F88}']
    function addTarget(targetName: JString): JTransition; cdecl; overload;//Deprecated
    function addTarget(targetType: Jlang_Class): JTransition; cdecl; overload;//Deprecated
    function addTarget(target: JView): JTransition; cdecl; overload;//Deprecated
    function clone: JTransition; cdecl;//Deprecated
    function createAnimator(sceneRoot: JViewGroup; startValues: JTransitionValues; endValues: JTransitionValues): JAnimator; cdecl;//Deprecated
    function excludeChildren(targetId: Integer; exclude: Boolean): JTransition; cdecl; overload;//Deprecated
    function excludeTarget(targetName: JString; exclude: Boolean): JTransition; cdecl; overload;//Deprecated
    function excludeTarget(target: JView; exclude: Boolean): JTransition; cdecl; overload;//Deprecated
    function excludeTarget(type_: Jlang_Class; exclude: Boolean): JTransition; cdecl; overload;//Deprecated
    function getInterpolator: JTimeInterpolator; cdecl;//Deprecated
    function getName: JString; cdecl;//Deprecated
    function getPathMotion: JPathMotion; cdecl;//Deprecated
    function getTargetNames: JList; cdecl;
    function getTargetTypes: JList; cdecl;
    function isTransitionRequired(startValues: JTransitionValues; endValues: JTransitionValues): Boolean; cdecl;
    function removeListener(listener: JTransition_TransitionListener): JTransition; cdecl;
    function removeTarget(targetId: Integer): JTransition; cdecl; overload;
    function setDuration(duration: Int64): JTransition; cdecl;
    procedure setEpicenterCallback(epicenterCallback: JTransition_EpicenterCallback); cdecl;
    function setInterpolator(interpolator: JTimeInterpolator): JTransition; cdecl;
    function setStartDelay(startDelay: Int64): JTransition; cdecl;
    function toString: JString; cdecl;
  end;
  TJTransition = class(TJavaGenericImport<JTransitionClass, JTransition>) end;

  JTransition_EpicenterCallbackClass = interface(JObjectClass)
    ['{8141257A-130B-466C-A08D-AA3A00946F4C}']
    {class} function init: JTransition_EpicenterCallback; cdecl;//Deprecated
  end;

  [JavaSignature('android/transition/Transition$EpicenterCallback')]
  JTransition_EpicenterCallback = interface(JObject)
    ['{CE004917-266F-4076-8913-F23184824FBA}']
    function onGetEpicenter(transition: JTransition): JRect; cdecl;//Deprecated
  end;
  TJTransition_EpicenterCallback = class(TJavaGenericImport<JTransition_EpicenterCallbackClass, JTransition_EpicenterCallback>) end;

  JTransition_TransitionListenerClass = interface(IJavaClass)
    ['{D5083752-E8A6-46DF-BE40-AE11073C387E}']
    {class} procedure onTransitionCancel(transition: JTransition); cdecl;//Deprecated
    {class} procedure onTransitionEnd(transition: JTransition); cdecl;//Deprecated
    {class} procedure onTransitionPause(transition: JTransition); cdecl;//Deprecated
  end;

  [JavaSignature('android/transition/Transition$TransitionListener')]
  JTransition_TransitionListener = interface(IJavaInstance)
    ['{C32BE107-6E05-4898-AF0A-FAD970D66E29}']
    procedure onTransitionResume(transition: JTransition); cdecl;//Deprecated
    procedure onTransitionStart(transition: JTransition); cdecl;//Deprecated
  end;
  TJTransition_TransitionListener = class(TJavaGenericImport<JTransition_TransitionListenerClass, JTransition_TransitionListener>) end;

  JTransitionManagerClass = interface(JObjectClass)
    ['{4160EFA0-3499-4964-817E-46497BB5B957}']
    {class} function init: JTransitionManager; cdecl;//Deprecated
    {class} procedure beginDelayedTransition(sceneRoot: JViewGroup); cdecl; overload;
    {class} procedure beginDelayedTransition(sceneRoot: JViewGroup; transition: JTransition); cdecl; overload;
    {class} procedure endTransitions(sceneRoot: JViewGroup); cdecl;
    {class} procedure go(scene: JScene); cdecl; overload;
    {class} procedure go(scene: JScene; transition: JTransition); cdecl; overload;
    {class} procedure setTransition(scene: JScene; transition: JTransition); cdecl; overload;
    {class} procedure setTransition(fromScene: JScene; toScene: JScene; transition: JTransition); cdecl; overload;
    {class} procedure transitionTo(scene: JScene); cdecl;
  end;

  [JavaSignature('android/transition/TransitionManager')]
  JTransitionManager = interface(JObject)
    ['{FF5E1210-1F04-4F81-9CAC-3D7A5C4E972B}']
  end;
  TJTransitionManager = class(TJavaGenericImport<JTransitionManagerClass, JTransitionManager>) end;

  JTransitionPropagationClass = interface(JObjectClass)
    ['{A881388A-C877-4DD9-9BAD-1BA4F56133EE}']
    {class} function init: JTransitionPropagation; cdecl;//Deprecated
    {class} function getPropagationProperties: TJavaObjectArray<JString>; cdecl;//Deprecated
    {class} function getStartDelay(sceneRoot: JViewGroup; transition: JTransition; startValues: JTransitionValues; endValues: JTransitionValues): Int64; cdecl;//Deprecated
  end;

  [JavaSignature('android/transition/TransitionPropagation')]
  JTransitionPropagation = interface(JObject)
    ['{7595B7EF-6BCE-4281-BC67-335E2FB6C091}']
    procedure captureValues(transitionValues: JTransitionValues); cdecl;//Deprecated
  end;
  TJTransitionPropagation = class(TJavaGenericImport<JTransitionPropagationClass, JTransitionPropagation>) end;

  JTransitionValuesClass = interface(JObjectClass)
    ['{3BF98CFA-6A4D-4815-8D42-15E97C916D91}']
    {class} function _Getvalues: JMap; cdecl;
    {class} function _Getview: JView; cdecl;
    {class} function init: JTransitionValues; cdecl;//Deprecated
    {class} function toString: JString; cdecl;//Deprecated
    {class} property values: JMap read _Getvalues;
    {class} property view: JView read _Getview;
  end;

  [JavaSignature('android/transition/TransitionValues')]
  JTransitionValues = interface(JObject)
    ['{178E09E6-D32C-48A9-ADCF-8CCEA804052A}']
    function equals(other: JObject): Boolean; cdecl;//Deprecated
    function hashCode: Integer; cdecl;//Deprecated
  end;
  TJTransitionValues = class(TJavaGenericImport<JTransitionValuesClass, JTransitionValues>) end;

  JInterpolatorClass = interface(JTimeInterpolatorClass)
    ['{A575B46A-E489-409C-807A-1B8F2BE092E8}']
  end;

  [JavaSignature('android/view/animation/Interpolator')]
  JInterpolator = interface(JTimeInterpolator)
    ['{F1082403-52DA-4AF0-B017-DAB334325FC7}']
  end;
  TJInterpolator = class(TJavaGenericImport<JInterpolatorClass, JInterpolator>) end;

  JToolbar_LayoutParamsClass = interface(JActionBar_LayoutParamsClass)
    ['{6D43796C-C163-4084-BB30-6FE68AFD7ABB}']
    {class} function init(c: JContext; attrs: JAttributeSet): JToolbar_LayoutParams; cdecl; overload;//Deprecated
    {class} function init(width: Integer; height: Integer): JToolbar_LayoutParams; cdecl; overload;//Deprecated
    {class} function init(width: Integer; height: Integer; gravity: Integer): JToolbar_LayoutParams; cdecl; overload;//Deprecated
    {class} function init(gravity: Integer): JToolbar_LayoutParams; cdecl; overload;//Deprecated
    {class} function init(source: JToolbar_LayoutParams): JToolbar_LayoutParams; cdecl; overload;//Deprecated
    {class} function init(source: JActionBar_LayoutParams): JToolbar_LayoutParams; cdecl; overload;//Deprecated
    {class} function init(source: JViewGroup_MarginLayoutParams): JToolbar_LayoutParams; cdecl; overload;//Deprecated
    {class} function init(source: JViewGroup_LayoutParams): JToolbar_LayoutParams; cdecl; overload;//Deprecated
  end;

  [JavaSignature('android/widget/Toolbar$LayoutParams')]
  JToolbar_LayoutParams = interface(JActionBar_LayoutParams)
    ['{BCD101F9-B7B7-4B2F-9460-056B3EA7B9F0}']
  end;
  TJToolbar_LayoutParams = class(TJavaGenericImport<JToolbar_LayoutParamsClass, JToolbar_LayoutParams>) end;

  JAplicacaoNaoInstaladaExcecaoClass = interface(JExceptionClass)
    ['{00EF79DF-E112-47D8-91F0-1C122CA56E67}']
    {class} function init: JAplicacaoNaoInstaladaExcecao; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/AplicacaoNaoInstaladaExcecao')]
  JAplicacaoNaoInstaladaExcecao = interface(JException)
    ['{9422E738-8B86-410C-9015-21F540E9EB48}']
  end;
  TJAplicacaoNaoInstaladaExcecao = class(TJavaGenericImport<JAplicacaoNaoInstaladaExcecaoClass, JAplicacaoNaoInstaladaExcecao>) end;

  Jinterfaceautomacao_BuildConfigClass = interface(JObjectClass)
    ['{0A2E653A-D433-4301-AD72-BFE9134B68D2}']
    {class} function _GetBUILD_TYPE: JString; cdecl;
    {class} function _GetDEBUG: Boolean; cdecl;
    {class} function _GetLIBRARY_PACKAGE_NAME: JString; cdecl;
    {class} function _GetVERSION_CODE: Integer; cdecl;
    {class} function _GetVERSION_NAME: JString; cdecl;
    {class} function init: Jinterfaceautomacao_BuildConfig; cdecl;
    {class} property BUILD_TYPE: JString read _GetBUILD_TYPE;
    {class} property DEBUG: Boolean read _GetDEBUG;
    {class} property LIBRARY_PACKAGE_NAME: JString read _GetLIBRARY_PACKAGE_NAME;
    {class} property VERSION_CODE: Integer read _GetVERSION_CODE;
    {class} property VERSION_NAME: JString read _GetVERSION_NAME;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/BuildConfig')]
  Jinterfaceautomacao_BuildConfig = interface(JObject)
    ['{5AB0D242-9A43-4E84-B451-CE92EB46313D}']
  end;
  TJinterfaceautomacao_BuildConfig = class(TJavaGenericImport<Jinterfaceautomacao_BuildConfigClass, Jinterfaceautomacao_BuildConfig>) end;

  JCartoesClass = interface(JEnumClass)
    ['{28D37624-150D-49FC-8BCD-2F3AEB22AC74}']
    {class} function _GetCARTAO_CREDITO: JCartoes; cdecl;
    {class} function _GetCARTAO_DEBITO: JCartoes; cdecl;
    {class} function _GetCARTAO_DESCONHECIDO: JCartoes; cdecl;
    {class} function _GetCARTAO_FROTA: JCartoes; cdecl;
    {class} function _GetCARTAO_PRIVATELABEL: JCartoes; cdecl;
    {class} function _GetCARTAO_VOUCHER: JCartoes; cdecl;
    {class} function obtemCartao(i: Integer): JCartoes; cdecl;
    {class} function valueOf(string_: JString): JCartoes; cdecl;
    {class} function values: TJavaObjectArray<JCartoes>; cdecl;//Deprecated
    {class} property CARTAO_CREDITO: JCartoes read _GetCARTAO_CREDITO;
    {class} property CARTAO_DEBITO: JCartoes read _GetCARTAO_DEBITO;
    {class} property CARTAO_DESCONHECIDO: JCartoes read _GetCARTAO_DESCONHECIDO;
    {class} property CARTAO_FROTA: JCartoes read _GetCARTAO_FROTA;
    {class} property CARTAO_PRIVATELABEL: JCartoes read _GetCARTAO_PRIVATELABEL;
    {class} property CARTAO_VOUCHER: JCartoes read _GetCARTAO_VOUCHER;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Cartoes')]
  JCartoes = interface(JEnum)
    ['{04A6F1B8-591E-4396-9D4C-C878DF22AB7C}']
    function obtemTipoCartao: Integer; cdecl;
  end;
  TJCartoes = class(TJavaGenericImport<JCartoesClass, JCartoes>) end;

  JComunicacaoServicoClass = interface(JIntentServiceClass)
    ['{F82B453D-CF78-4297-9506-D259D3A3F395}']
    {class} function init: JComunicacaoServico; cdecl;
    {class} procedure setfTransInic(b: Boolean); cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/ComunicacaoServico')]
  JComunicacaoServico = interface(JIntentService)
    ['{428581B1-F3B1-42C6-A68F-D1F9E26B86FC}']
    function onBind(intent: JIntent): JIBinder; cdecl;
    function onStartCommand(intent: JIntent; i: Integer; i1: Integer): Integer; cdecl;
    function onUnbind(intent: JIntent): Boolean; cdecl;
    procedure retornoCliente(i: Integer; string_: JString; string_1: JString); cdecl;
  end;
  TJComunicacaoServico = class(TJavaGenericImport<JComunicacaoServicoClass, JComunicacaoServico>) end;

  JComunicacaoServico_IncomingHandlerClass = interface(JHandlerClass)
    ['{A3A8B5F3-5779-47D7-BE33-4ABD29227B4A}']
    {class} function init(comunicacaoServico: JComunicacaoServico; comunicacaoServico1: JComunicacaoServico): JComunicacaoServico_IncomingHandler; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/ComunicacaoServico$IncomingHandler')]
  JComunicacaoServico_IncomingHandler = interface(JHandler)
    ['{6409B083-41AE-48D9-8573-147C631C091C}']
    procedure handleMessage(message: JMessage); cdecl;
  end;
  TJComunicacaoServico_IncomingHandler = class(TJavaGenericImport<JComunicacaoServico_IncomingHandlerClass, JComunicacaoServico_IncomingHandler>) end;

  JConfirmacaoClass = interface(JSerializableClass)
    ['{73A6A55C-16B0-4ACF-9229-FC5D6E0397A3}']
    {class} function init: JConfirmacao; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Confirmacao')]
  JConfirmacao = interface(JSerializable)
    ['{91C0D191-4E90-44EE-AB60-665959131B97}']
    function informaStatusTransacao(statusTransacao: JStatusTransacao): JConfirmacao; cdecl;
    function obtemStatusTransacao: JStatusTransacao; cdecl;
  end;
  TJConfirmacao = class(TJavaGenericImport<JConfirmacaoClass, JConfirmacao>) end;

  JConfirmacoesClass = interface(JConfirmacaoClass)
    ['{6A4B078B-DD77-41D4-BC78-742A28EE730B}']
    {class} function init: JConfirmacoes; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Confirmacoes')]
  JConfirmacoes = interface(JConfirmacao)
    ['{6310929D-3977-4C0A-A32D-92DB0A0B4AED}']
    function informaIdentificadorConfirmacaoTransacao(string_: JString): JConfirmacoes; cdecl;
    function obtemIdentificadorTransacao: JString; cdecl;
  end;
  TJConfirmacoes = class(TJavaGenericImport<JConfirmacoesClass, JConfirmacoes>) end;

  JDadosAutomacaoClass = interface(JSerializableClass)
    ['{D21776C6-0472-4DB2-8D5F-CF10071732F9}']
    {class} function init(string_: JString; string_1: JString; string_2: JString; b: Boolean; b1: Boolean; b2: Boolean; b3: Boolean): JDadosAutomacao; cdecl; overload;
    {class} function init(string_: JString; string_1: JString; string_2: JString; b: Boolean; b1: Boolean; b2: Boolean; b3: Boolean; personalizacao: JPersonalizacao): JDadosAutomacao; cdecl; overload;
    {class} function init(string_: JString; string_1: JString; string_2: JString; b: Boolean; b1: Boolean; b2: Boolean; b3: Boolean; b4: Boolean; personalizacao: JPersonalizacao): JDadosAutomacao; cdecl; overload;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/DadosAutomacao')]
  JDadosAutomacao = interface(JSerializable)
    ['{35C3A2DF-3ECF-45FB-8883-B4B5B9D0B8D8}']
    function obtemEmpresaAutomacao: JString; cdecl;
    function obtemNomeAutomacao: JString; cdecl;
    function obtemPersonalizacaoCliente: JPersonalizacao; cdecl;
    function obtemVersaoAutomacao: JString; cdecl;
    function suportaAbatimentoSaldoVoucher: Boolean; cdecl;
    function suportaDesconto: Boolean; cdecl;
    function suportaTroco: Boolean; cdecl;
    function suportaViaReduzida: Boolean; cdecl;
    function suportaViasDiferneciadas: Boolean; cdecl;
  end;
  TJDadosAutomacao = class(TJavaGenericImport<JDadosAutomacaoClass, JDadosAutomacao>) end;

  JEntradaTransacaoClass = interface(JSerializableClass)
    ['{46249D08-5BCE-4F65-92A9-09202313AF04}']
    {class} function init(operacoes: JOperacoes; string_: JString): JEntradaTransacao; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/EntradaTransacao')]
  JEntradaTransacao = interface(JSerializable)
    ['{B85F486C-A4DE-4063-BD4C-82321B11FCB4}']
    function informaCodigoAutorizacaoOriginal(string_: JString): JEntradaTransacao; cdecl;
    function informaCodigoMoeda(string_: JString): JEntradaTransacao; cdecl;
    function informaDadosAdicionaisAutomacao1(string_: JString): JEntradaTransacao; cdecl;
    function informaDadosAdicionaisAutomacao2(string_: JString): JEntradaTransacao; cdecl;
    function informaDadosAdicionaisAutomacao3(string_: JString): JEntradaTransacao; cdecl;
    function informaDadosAdicionaisAutomacao4(string_: JString): JEntradaTransacao; cdecl;
    function informaDataHoraTransacaoOriginal(date: JDate): JEntradaTransacao; cdecl;
    function informaDataPredatado(date: JDate): JEntradaTransacao; cdecl;
    function informaDocumentoFiscal(string_: JString): JEntradaTransacao; cdecl;
    function informaEstabelecimentoCNPJouCPF(string_: JString): JEntradaTransacao; cdecl;
    function informaModalidadePagamento(modalidadesPagamento: JModalidadesPagamento): JEntradaTransacao; cdecl;
    function informaNomeProvedor(string_: JString): JEntradaTransacao; cdecl;
    function informaNsuTransacaoOriginal(string_: JString): JEntradaTransacao; cdecl;
    function informaNumeroFatura(string_: JString): JEntradaTransacao; cdecl;
    function informaNumeroParcelas(i: Integer): JEntradaTransacao; cdecl;
    function informaNumeroTelefone(string_: JString): JEntradaTransacao; cdecl;
    function informaProvedor(provedores: JProvedores): JEntradaTransacao; cdecl;
    function informaTaxaEmbarque(string_: JString): JEntradaTransacao; cdecl;
    function informaTaxaServico(string_: JString): JEntradaTransacao; cdecl;
    function informaTipoCartao(cartoes: JCartoes): JEntradaTransacao; cdecl;
    function informaTipoFinanciamento(financiamentos: JFinanciamentos): JEntradaTransacao; cdecl;
    function informaValorTotal(string_: JString): JEntradaTransacao; cdecl;
    function obtemCodigoAutorizacaoOriginal: JString; cdecl;
    function obtemCodigoMoeda: JString; cdecl;
    function obtemDadosAdicionaisAutomacao1: JString; cdecl;
    function obtemDadosAdicionaisAutomacao2: JString; cdecl;
    function obtemDadosAdicionaisAutomacao3: JString; cdecl;
    function obtemDadosAdicionaisAutomacao4: JString; cdecl;
    function obtemDataHoraTransacaoOriginal: JDate; cdecl;
    function obtemDataPredatado: JDate; cdecl;
    function obtemDocumentoFiscal: JString; cdecl;
    function obtemEstabelecimentoCNPJouCPF: JString; cdecl;
    function obtemIdTransacaoAutomacao: JString; cdecl;
    function obtemModalidadePagamento: JModalidadesPagamento; cdecl;
    function obtemNomeProvedor: JString; cdecl;
    function obtemNsuTransacaoOriginal: JString; cdecl;
    function obtemNumeroFatura: JString; cdecl;
    function obtemNumeroParcelas: Integer; cdecl;
    function obtemNumeroTelefone: JString; cdecl;
    function obtemOperacao: JOperacoes; cdecl;
    function obtemProvedor: JProvedores; cdecl;
    function obtemTaxaEmbarque: JString; cdecl;
    function obtemTaxaServico: JString; cdecl;
    function obtemTipoCartao: JCartoes; cdecl;
    function obtemTipoFinanciamento: JFinanciamentos; cdecl;
    function obtemValorTotal: JString; cdecl;
  end;
  TJEntradaTransacao = class(TJavaGenericImport<JEntradaTransacaoClass, JEntradaTransacao>) end;

  JFinanciamentosClass = interface(JEnumClass)
    ['{9A00CED6-C11B-4241-AE02-A99EC4C5136A}']
    {class} function _GetA_VISTA: JFinanciamentos; cdecl;
    {class} function _GetCREDITO_EMISSOR: JFinanciamentos; cdecl;
    {class} function _GetFINANCIAMENTO_NAO_DEFINIDO: JFinanciamentos; cdecl;
    {class} function _GetPARCELADO_EMISSOR: JFinanciamentos; cdecl;
    {class} function _GetPARCELADO_ESTABELECIMENTO: JFinanciamentos; cdecl;
    {class} function _GetPRE_DATADO: JFinanciamentos; cdecl;
    {class} function obtemFinanciamento(i: Integer): JFinanciamentos; cdecl;
    {class} function valueOf(string_: JString): JFinanciamentos; cdecl;
    {class} function values: TJavaObjectArray<JFinanciamentos>; cdecl;//Deprecated
    {class} property A_VISTA: JFinanciamentos read _GetA_VISTA;
    {class} property CREDITO_EMISSOR: JFinanciamentos read _GetCREDITO_EMISSOR;
    {class} property FINANCIAMENTO_NAO_DEFINIDO: JFinanciamentos read _GetFINANCIAMENTO_NAO_DEFINIDO;
    {class} property PARCELADO_EMISSOR: JFinanciamentos read _GetPARCELADO_EMISSOR;
    {class} property PARCELADO_ESTABELECIMENTO: JFinanciamentos read _GetPARCELADO_ESTABELECIMENTO;
    {class} property PRE_DATADO: JFinanciamentos read _GetPRE_DATADO;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Financiamentos')]
  JFinanciamentos = interface(JEnum)
    ['{C9C051BC-AC50-4C02-8EB4-742A712BFBDA}']
    function obtemCodigoFinanciamento: Integer; cdecl;
  end;
  TJFinanciamentos = class(TJavaGenericImport<JFinanciamentosClass, JFinanciamentos>) end;

  JGlobalDefsClass = interface(IJavaClass)
    ['{BCBBC2F1-05F4-40ED-9780-FE499E0C0CE7}']
    {class} function _GetAPP_URI: JString; cdecl;
    {class} function _GetCLIENTE_NAO_CONFIGURADO: Integer; cdecl;
    {class} function _GetCLIENTE_NAO_INSTALADO: Integer; cdecl;
    {class} function _GetCONFIRMACAO_EXTRA: JString; cdecl;
    {class} function _GetCONFIRM_URI: JString; cdecl;
    {class} function _GetDADOS_EXTRA: JString; cdecl;
    {class} function _GetENTRADA_EXTRA: JString; cdecl;
    {class} function _GetPAYMENT_URI: JString; cdecl;
    {class} function _GetPENDENCIA_EXTRA: JString; cdecl;
    {class} function _GetPERSONALIZACAO: JString; cdecl;
    {class} function _GetRESOLVE_URI: JString; cdecl;
    {class} property APP_URI: JString read _GetAPP_URI;
    {class} property CLIENTE_NAO_CONFIGURADO: Integer read _GetCLIENTE_NAO_CONFIGURADO;
    {class} property CLIENTE_NAO_INSTALADO: Integer read _GetCLIENTE_NAO_INSTALADO;
    {class} property CONFIRMACAO_EXTRA: JString read _GetCONFIRMACAO_EXTRA;
    {class} property CONFIRM_URI: JString read _GetCONFIRM_URI;
    {class} property DADOS_EXTRA: JString read _GetDADOS_EXTRA;
    {class} property ENTRADA_EXTRA: JString read _GetENTRADA_EXTRA;
    {class} property PAYMENT_URI: JString read _GetPAYMENT_URI;
    {class} property PENDENCIA_EXTRA: JString read _GetPENDENCIA_EXTRA;
    {class} property PERSONALIZACAO: JString read _GetPERSONALIZACAO;
    {class} property RESOLVE_URI: JString read _GetRESOLVE_URI;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/GlobalDefs')]
  JGlobalDefs = interface(IJavaInstance)
    ['{F88E707E-76E7-430A-9EB4-71073C131617}']
  end;
  TJGlobalDefs = class(TJavaGenericImport<JGlobalDefsClass, JGlobalDefs>) end;

  JIdentificacaoPortadorCarteiraClass = interface(JEnumClass)
    ['{7526BDAB-1AE8-42C9-B37E-41EB2084CF5D}']
    {class} function _GetCPF: JIdentificacaoPortadorCarteira; cdecl;
    {class} function _GetOUTROS: JIdentificacaoPortadorCarteira; cdecl;
    {class} function _GetQRCODE: JIdentificacaoPortadorCarteira; cdecl;
    {class} function obtemIdentificador(i: Integer): JIdentificacaoPortadorCarteira; cdecl; overload;
    {class} function valueOf(string_: JString): JIdentificacaoPortadorCarteira; cdecl;
    {class} function values: TJavaObjectArray<JIdentificacaoPortadorCarteira>; cdecl;//Deprecated
    {class} property CPF: JIdentificacaoPortadorCarteira read _GetCPF;
    {class} property OUTROS: JIdentificacaoPortadorCarteira read _GetOUTROS;
    {class} property QRCODE: JIdentificacaoPortadorCarteira read _GetQRCODE;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/IdentificacaoPortadorCarteira')]
  JIdentificacaoPortadorCarteira = interface(JEnum)
    ['{C9F2F3EC-A0C3-4B7C-B6A5-E2C5E67FB309}']
    function obtemIdentificador: Integer; cdecl; overload;
  end;
  TJIdentificacaoPortadorCarteira = class(TJavaGenericImport<JIdentificacaoPortadorCarteiraClass, JIdentificacaoPortadorCarteira>) end;

  JModalidadesPagamentoClass = interface(JEnumClass)
    ['{8746E9E5-55D3-4D51-A6B0-556E330BCD7B}']
    {class} function _GetPAGAMENTO_CARTAO: JModalidadesPagamento; cdecl;
    {class} function _GetPAGAMENTO_CARTEIRA_VIRTUAL: JModalidadesPagamento; cdecl;
    {class} function _GetPAGAMENTO_CHEQUE: JModalidadesPagamento; cdecl;
    {class} function _GetPAGAMENTO_DINHEIRO: JModalidadesPagamento; cdecl;
    {class} function valueOf(string_: JString): JModalidadesPagamento; cdecl;
    {class} function values: TJavaObjectArray<JModalidadesPagamento>; cdecl;//Deprecated
    {class} property PAGAMENTO_CARTAO: JModalidadesPagamento read _GetPAGAMENTO_CARTAO;
    {class} property PAGAMENTO_CARTEIRA_VIRTUAL: JModalidadesPagamento read _GetPAGAMENTO_CARTEIRA_VIRTUAL;
    {class} property PAGAMENTO_CHEQUE: JModalidadesPagamento read _GetPAGAMENTO_CHEQUE;
    {class} property PAGAMENTO_DINHEIRO: JModalidadesPagamento read _GetPAGAMENTO_DINHEIRO;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/ModalidadesPagamento')]
  JModalidadesPagamento = interface(JEnum)
    ['{B862AF2D-67D3-4C5F-8632-59A474395555}']
  end;
  TJModalidadesPagamento = class(TJavaGenericImport<JModalidadesPagamentoClass, JModalidadesPagamento>) end;

  JModalidadesTransacaoClass = interface(JEnumClass)
    ['{069485B9-2FFA-4D9F-92BA-3495C25E4335}']
    {class} function _GetOFF: JModalidadesTransacao; cdecl;
    {class} function _GetON: JModalidadesTransacao; cdecl;
    {class} function valueOf(string_: JString): JModalidadesTransacao; cdecl;
    {class} function values: TJavaObjectArray<JModalidadesTransacao>; cdecl;//Deprecated
    {class} property OFF: JModalidadesTransacao read _GetOFF;
    {class} property ON: JModalidadesTransacao read _GetON;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/ModalidadesTransacao')]
  JModalidadesTransacao = interface(JEnum)
    ['{7BAE5A3B-02B7-43AC-A848-76FC06883C5C}']
  end;
  TJModalidadesTransacao = class(TJavaGenericImport<JModalidadesTransacaoClass, JModalidadesTransacao>) end;

  JOperacoesClass = interface(JEnumClass)
    ['{6DE6DCEE-85C1-40DE-93D6-0CBDCF5D8931}']
    {class} function _GetADMINISTRATIVA: JOperacoes; cdecl;
    {class} function _GetCANCELAMENTO: JOperacoes; cdecl;
    {class} function _GetCANCELAMENTO_PAGAMENTOCONTA: JOperacoes; cdecl;
    {class} function _GetCANCELAMENTO_PREAUTORIZACAO: JOperacoes; cdecl;
    {class} function _GetCONFIGURACAO: JOperacoes; cdecl;
    {class} function _GetCONSULTA_CHEQUE: JOperacoes; cdecl;
    {class} function _GetCONSULTA_SALDO: JOperacoes; cdecl;
    {class} function _GetDOACAO: JOperacoes; cdecl;
    {class} function _GetEXIBE_PDC: JOperacoes; cdecl;
    {class} function _GetFECHAMENTO: JOperacoes; cdecl;
    {class} function _GetGARANTIA_CHEQUE: JOperacoes; cdecl;
    {class} function _GetINSTALACAO: JOperacoes; cdecl;
    {class} function _GetMANUTENCAO: JOperacoes; cdecl;
    {class} function _GetOPERACAO_DESCONHECIDA: JOperacoes; cdecl;
    {class} function _GetPAGAMENTO_CONTA: JOperacoes; cdecl;
    {class} function _GetPREAUTORIZACAO: JOperacoes; cdecl;
    {class} function _GetRECARGA_CELULAR: JOperacoes; cdecl;
    {class} function _GetREIMPRESSAO: JOperacoes; cdecl;
    {class} function _GetRELATORIO_DETALHADO: JOperacoes; cdecl;
    {class} function _GetRELATORIO_RESUMIDO: JOperacoes; cdecl;
    {class} function _GetRELATORIO_SINTETICO: JOperacoes; cdecl;
    {class} function _GetSAQUE: JOperacoes; cdecl;
    {class} function _GetTESTE_COMUNICACAO: JOperacoes; cdecl;
    {class} function _GetVENDA: JOperacoes; cdecl;
    {class} function _GetVERSAO: JOperacoes; cdecl;
    {class} function obtemOperacao(i: Integer): JOperacoes; cdecl;
    {class} function valueOf(string_: JString): JOperacoes; cdecl;
    {class} function values: TJavaObjectArray<JOperacoes>; cdecl;//Deprecated
    {class} property ADMINISTRATIVA: JOperacoes read _GetADMINISTRATIVA;
    {class} property CANCELAMENTO: JOperacoes read _GetCANCELAMENTO;
    {class} property CANCELAMENTO_PAGAMENTOCONTA: JOperacoes read _GetCANCELAMENTO_PAGAMENTOCONTA;
    {class} property CANCELAMENTO_PREAUTORIZACAO: JOperacoes read _GetCANCELAMENTO_PREAUTORIZACAO;
    {class} property CONFIGURACAO: JOperacoes read _GetCONFIGURACAO;
    {class} property CONSULTA_CHEQUE: JOperacoes read _GetCONSULTA_CHEQUE;
    {class} property CONSULTA_SALDO: JOperacoes read _GetCONSULTA_SALDO;
    {class} property DOACAO: JOperacoes read _GetDOACAO;
    {class} property EXIBE_PDC: JOperacoes read _GetEXIBE_PDC;
    {class} property FECHAMENTO: JOperacoes read _GetFECHAMENTO;
    {class} property GARANTIA_CHEQUE: JOperacoes read _GetGARANTIA_CHEQUE;
    {class} property INSTALACAO: JOperacoes read _GetINSTALACAO;
    {class} property MANUTENCAO: JOperacoes read _GetMANUTENCAO;
    {class} property OPERACAO_DESCONHECIDA: JOperacoes read _GetOPERACAO_DESCONHECIDA;
    {class} property PAGAMENTO_CONTA: JOperacoes read _GetPAGAMENTO_CONTA;
    {class} property PREAUTORIZACAO: JOperacoes read _GetPREAUTORIZACAO;
    {class} property RECARGA_CELULAR: JOperacoes read _GetRECARGA_CELULAR;
    {class} property REIMPRESSAO: JOperacoes read _GetREIMPRESSAO;
    {class} property RELATORIO_DETALHADO: JOperacoes read _GetRELATORIO_DETALHADO;
    {class} property RELATORIO_RESUMIDO: JOperacoes read _GetRELATORIO_RESUMIDO;
    {class} property RELATORIO_SINTETICO: JOperacoes read _GetRELATORIO_SINTETICO;
    {class} property SAQUE: JOperacoes read _GetSAQUE;
    {class} property TESTE_COMUNICACAO: JOperacoes read _GetTESTE_COMUNICACAO;
    {class} property VENDA: JOperacoes read _GetVENDA;
    {class} property VERSAO: JOperacoes read _GetVERSAO;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Operacoes')]
  JOperacoes = interface(JEnum)
    ['{9EC48B94-5611-41C9-A46D-9A020CD5B816}']
    function obtemTagOperacao: Integer; cdecl;
  end;
  TJOperacoes = class(TJavaGenericImport<JOperacoesClass, JOperacoes>) end;

  JPersonalizacaoClass = interface(JSerializableClass)
    ['{B7FF8F15-5AA3-4B7D-8F11-28DC0C4D9326}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Personalizacao')]
  JPersonalizacao = interface(JSerializable)
    ['{63E04B77-F9E4-4598-B7CB-B6C2C71B6E55}']
    function obtemCorFonte: JString; cdecl;
    function obtemCorFonteTeclado: JString; cdecl;
    function obtemCorFundoCaixaEdicao: JString; cdecl;
    function obtemCorFundoTeclado: JString; cdecl;
    function obtemCorFundoTela: JString; cdecl;
    function obtemCorFundoToolbar: JString; cdecl;
    function obtemCorSeparadorMenu: JString; cdecl;
    function obtemCorTeclaLiberadaTeclado: JString; cdecl;
    function obtemCorTeclaPressionadaTeclado: JString; cdecl;
    function obtemCorTextoCaixaEdicao: JString; cdecl;
    function obtemFonte: JFile; cdecl;
    function obtemIconeToolbar: JFile; cdecl;
  end;
  TJPersonalizacao = class(TJavaGenericImport<JPersonalizacaoClass, JPersonalizacao>) end;

  JPersonalizacao_1Class = interface(JObjectClass)
    ['{D3A32146-E0B9-45EC-A7EB-36CE997D3079}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Personalizacao$1')]
  JPersonalizacao_1 = interface(JObject)
    ['{8D5A8342-DEE8-4CC6-9928-38DEDA200517}']
  end;
  TJPersonalizacao_1 = class(TJavaGenericImport<JPersonalizacao_1Class, JPersonalizacao_1>) end;

  JPersonalizacao_BuilderClass = interface(JObjectClass)
    ['{9CDF7A15-45DF-49E5-B143-22F1C5E68C42}']
    {class} function init: JPersonalizacao_Builder; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Personalizacao$Builder')]
  JPersonalizacao_Builder = interface(JObject)
    ['{46847789-5BF8-412A-9377-67FFEB2D631B}']
    function build: JPersonalizacao; cdecl;
    function informaCorFonte(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaCorFonteTeclado(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaCorFundoCaixaEdicao(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaCorFundoTeclado(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaCorFundoTela(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaCorFundoToolbar(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaCorSeparadorMenu(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaCorTeclaLiberadaTeclado(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaCorTeclaPressionadaTeclado(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaCorTextoCaixaEdicao(string_: JString): JPersonalizacao_Builder; cdecl;
    function informaFonte(file_: JFile): JPersonalizacao_Builder; cdecl;
    function informaIconeToolbar(file_: JFile): JPersonalizacao_Builder; cdecl;
  end;
  TJPersonalizacao_Builder = class(TJavaGenericImport<JPersonalizacao_BuilderClass, JPersonalizacao_Builder>) end;

  JProvedoresClass = interface(JEnumClass)
    ['{0BD978D3-7A51-4A91-BB1F-E5329ABC171F}']
    {class} function _GetACCORD: JProvedores; cdecl;
    {class} function _GetALGORIX: JProvedores; cdecl;
    {class} function _GetAMEX: JProvedores; cdecl;
    {class} function _GetBANCREDCARD: JProvedores; cdecl;
    {class} function _GetBANESE: JProvedores; cdecl;
    {class} function _GetBANRISUL: JProvedores; cdecl;
    {class} function _GetCIELO: JProvedores; cdecl;
    {class} function _GetCONDUCTOR: JProvedores; cdecl;
    {class} function _GetCOOPERCRED: JProvedores; cdecl;
    {class} function _GetCREDISHOP: JProvedores; cdecl;
    {class} function _GetELAVON: JProvedores; cdecl;
    {class} function _GetFANCARD: JProvedores; cdecl;
    {class} function _GetFILLIP: JProvedores; cdecl;
    {class} function _GetFIRSTDATA: JProvedores; cdecl;
    {class} function _GetGETNET: JProvedores; cdecl;
    {class} function _GetHIPERCARD: JProvedores; cdecl;
    {class} function _GetLIBERCARD: JProvedores; cdecl;
    {class} function _GetM4U: JProvedores; cdecl;
    {class} function _GetMUXX: JProvedores; cdecl;
    {class} function _GetNEUS: JProvedores; cdecl;
    {class} function _GetORGCARD: JProvedores; cdecl;
    {class} function _GetPOLICARD: JProvedores; cdecl;
    {class} function _GetPREMMIA: JProvedores; cdecl;
    {class} function _GetPREPAG: JProvedores; cdecl;
    {class} function _GetPROVEDOR_DESCONHECIDO: JProvedores; cdecl;
    {class} function _GetREDECARD: JProvedores; cdecl;
    {class} function _GetREPOM: JProvedores; cdecl;
    {class} function _GetRV: JProvedores; cdecl;
    {class} function _GetSENFF: JProvedores; cdecl;
    {class} function _GetTECPOINT: JProvedores; cdecl;
    {class} function _GetTICKETCAR: JProvedores; cdecl;
    {class} function _GetTRICARD: JProvedores; cdecl;
    {class} function _GetVALECARD: JProvedores; cdecl;
    {class} function _GetVERYCARD: JProvedores; cdecl;
    {class} function obtemProvedor(string_: JString): JProvedores; cdecl;
    {class} function valueOf(string_: JString): JProvedores; cdecl;
    {class} function values: TJavaObjectArray<JProvedores>; cdecl;//Deprecated
    {class} property ACCORD: JProvedores read _GetACCORD;
    {class} property ALGORIX: JProvedores read _GetALGORIX;
    {class} property AMEX: JProvedores read _GetAMEX;
    {class} property BANCREDCARD: JProvedores read _GetBANCREDCARD;
    {class} property BANESE: JProvedores read _GetBANESE;
    {class} property BANRISUL: JProvedores read _GetBANRISUL;
    {class} property CIELO: JProvedores read _GetCIELO;
    {class} property CONDUCTOR: JProvedores read _GetCONDUCTOR;
    {class} property COOPERCRED: JProvedores read _GetCOOPERCRED;
    {class} property CREDISHOP: JProvedores read _GetCREDISHOP;
    {class} property ELAVON: JProvedores read _GetELAVON;
    {class} property FANCARD: JProvedores read _GetFANCARD;
    {class} property FILLIP: JProvedores read _GetFILLIP;
    {class} property FIRSTDATA: JProvedores read _GetFIRSTDATA;
    {class} property GETNET: JProvedores read _GetGETNET;
    {class} property HIPERCARD: JProvedores read _GetHIPERCARD;
    {class} property LIBERCARD: JProvedores read _GetLIBERCARD;
    {class} property M4U: JProvedores read _GetM4U;
    {class} property MUXX: JProvedores read _GetMUXX;
    {class} property NEUS: JProvedores read _GetNEUS;
    {class} property ORGCARD: JProvedores read _GetORGCARD;
    {class} property POLICARD: JProvedores read _GetPOLICARD;
    {class} property PREMMIA: JProvedores read _GetPREMMIA;
    {class} property PREPAG: JProvedores read _GetPREPAG;
    {class} property PROVEDOR_DESCONHECIDO: JProvedores read _GetPROVEDOR_DESCONHECIDO;
    {class} property REDECARD: JProvedores read _GetREDECARD;
    {class} property REPOM: JProvedores read _GetREPOM;
    {class} property RV: JProvedores read _GetRV;
    {class} property SENFF: JProvedores read _GetSENFF;
    {class} property TECPOINT: JProvedores read _GetTECPOINT;
    {class} property TICKETCAR: JProvedores read _GetTICKETCAR;
    {class} property TRICARD: JProvedores read _GetTRICARD;
    {class} property VALECARD: JProvedores read _GetVALECARD;
    {class} property VERYCARD: JProvedores read _GetVERYCARD;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Provedores')]
  JProvedores = interface(JEnum)
    ['{BB8FC0C3-EB73-43A0-A2F2-93871E50DD0F}']
  end;
  TJProvedores = class(TJavaGenericImport<JProvedoresClass, JProvedores>) end;

  JQuedaConexaoTerminalExcecaoClass = interface(JRuntimeExceptionClass)
    ['{E9E197EB-3DC2-4952-867E-05FD53253D31}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/QuedaConexaoTerminalExcecao')]
  JQuedaConexaoTerminalExcecao = interface(JRuntimeException)
    ['{7FC1B9AD-5280-43AF-AB9F-5C9966B2051A}']
  end;
  TJQuedaConexaoTerminalExcecao = class(TJavaGenericImport<JQuedaConexaoTerminalExcecaoClass, JQuedaConexaoTerminalExcecao>) end;

  JSaidaTransacaoClass = interface(JSerializableClass)
    ['{B857101D-8C3B-4334-9EE0-3D44B92B52AE}']
    {class} function init: JSaidaTransacao; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/SaidaTransacao')]
  JSaidaTransacao = interface(JSerializable)
    ['{76773630-B60F-4394-937C-54244AD944B1}']
    function comprovanteGraficoDisponivel: Boolean; cdecl;
    function existeTransacaoPendente: Boolean; cdecl;
    function informaAidCartao(string_: JString): JSaidaTransacao; cdecl;
    function informaCodigoAutorizacao(string_: JString): JSaidaTransacao; cdecl;
    function informaCodigoAutorizacaoOriginal(string_: JString): JSaidaTransacao; cdecl;
    function informaCodigoMoeda(string_: JString): JSaidaTransacao; cdecl;
    function informaCodigoRespostaProvedor(string_: JString): JSaidaTransacao; cdecl;
    function informaComprovanteCompleto(list: JList): JSaidaTransacao; cdecl;
    function informaComprovanteDiferenciadoLoja(list: JList): JSaidaTransacao; cdecl;
    function informaComprovanteDiferenciadoPortador(list: JList): JSaidaTransacao; cdecl;
    function informaComprovanteGraficoLojista(string_: JString): JSaidaTransacao; cdecl;
    function informaComprovanteGraficoPortador(string_: JString): JSaidaTransacao; cdecl;
    function informaComprovanteReduzidoPortador(list: JList): JSaidaTransacao; cdecl;
    procedure informaDadosTransacaoPendente(transacaoPendenteDados: JTransacaoPendenteDados); cdecl;
    function informaDataHoraTransacao(date: JDate): JSaidaTransacao; cdecl;
    function informaDataHoraTransacaoOriginal(date: JDate): JSaidaTransacao; cdecl;
    function informaDataPredatado(date: JDate): JSaidaTransacao; cdecl;
    function informaDocumentoFiscal(string_: JString): JSaidaTransacao; cdecl;
    function informaExisteComprovanteGrafico(b: Boolean): JSaidaTransacao; cdecl;
    procedure informaExisteTransacaoPendente(b: Boolean); cdecl;
    procedure informaIdentificacaoPortadorCarteira(identificacaoPortadorCarteira: JIdentificacaoPortadorCarteira); cdecl;
    function informaIdentificadorConfirmacaoTransacao(string_: JString): JSaidaTransacao; cdecl;
    function informaIdentificadorEstabelecimento(string_: JString): JSaidaTransacao; cdecl;
    function informaIdentificadorPontoCaptura(string_: JString): JSaidaTransacao; cdecl;
    function informaIdentificadorTransacaoAutomacao(string_: JString): JSaidaTransacao; cdecl;
    function informaMensagemResultado(string_: JString): JSaidaTransacao; cdecl;
    procedure informaModalidadePagamento(modalidadesPagamento: JModalidadesPagamento); cdecl;
    procedure informaModalidadeTransacao(modalidadesTransacao: JModalidadesTransacao); cdecl;
    function informaModoEntradaCartao(string_: JString): JSaidaTransacao; cdecl;
    function informaModoVerificacaoSenha(string_: JString): JSaidaTransacao; cdecl;
    function informaNomeCartao(string_: JString): JSaidaTransacao; cdecl;
    function informaNomeCartaoPadrao(string_: JString): JSaidaTransacao; cdecl;
    function informaNomeEstabelecimento(string_: JString): JSaidaTransacao; cdecl;
    function informaNomePortadorCartao(string_: JString): JSaidaTransacao; cdecl;
    function informaNomeProvedor(string_: JString): JSaidaTransacao; cdecl;
    function informaNsuHost(string_: JString): JSaidaTransacao; cdecl;
    function informaNsuHostOriginal(string_: JString): JSaidaTransacao; cdecl;
    function informaNsuLocal(string_: JString): JSaidaTransacao; cdecl;
    function informaNsuLocalOriginal(string_: JString): JSaidaTransacao; cdecl;
    function informaNumeroParcelas(i: Integer): JSaidaTransacao; cdecl;
    function informaOperacao(operacoes: JOperacoes): JSaidaTransacao; cdecl;
    function informaPanMascarado(string_: JString): JSaidaTransacao; cdecl;
    function informaPanMascaradoPadrao(string_: JString): JSaidaTransacao; cdecl;
    function informaProvedor(provedores: JProvedores): JSaidaTransacao; cdecl;
    function informaRequerConfirmacao(b: Boolean): JSaidaTransacao; cdecl;
    function informaResultadoTransacao(i: Integer): JSaidaTransacao; cdecl;
    function informaSaldoVoucher(string_: JString): JSaidaTransacao; cdecl;
    function informaTipoCartao(cartoes: JCartoes): JSaidaTransacao; cdecl;
    function informaTipoFinanciamento(financiamentos: JFinanciamentos): JSaidaTransacao; cdecl;
    procedure informaUniqueID(string_: JString); cdecl;
    function informaValorDesconto(string_: JString): JSaidaTransacao; cdecl;
    function informaValorDevido(string_: JString): JSaidaTransacao; cdecl;
    function informaValorOriginal(string_: JString): JSaidaTransacao; cdecl;
    function informaValorTotal(string_: JString): JSaidaTransacao; cdecl;
    function informaValorTroco(string_: JString): JSaidaTransacao; cdecl;
    function informaViasImprimir(viasImpressao: JViasImpressao): JSaidaTransacao; cdecl;
    function obtemAidCartao: JString; cdecl;
    function obtemCodigoAutorizacao: JString; cdecl;
    function obtemCodigoAutorizacaoOriginal: JString; cdecl;
    function obtemCodigoMoeda: JString; cdecl;
    function obtemCodigoRespostaProvedor: JString; cdecl;
    function obtemComprovanteCompleto: JList; cdecl;
    function obtemComprovanteDiferenciadoLoja: JList; cdecl;
    function obtemComprovanteDiferenciadoPortador: JList; cdecl;
    function obtemComprovanteGraficoLojista: JString; cdecl;
    function obtemComprovanteGraficoPortador: JString; cdecl;
    function obtemComprovanteReduzidoPortador: JList; cdecl;
    function obtemDadosTransacaoPendente: JTransacaoPendenteDados; cdecl;
    function obtemDataHoraTransacao: JDate; cdecl;
    function obtemDataHoraTransacaoOriginal: JDate; cdecl;
    function obtemDataPredatado: JDate; cdecl;
    function obtemDocumentoFiscal: JString; cdecl;
    function obtemIdentificacaoPortadorCarteira: JIdentificacaoPortadorCarteira; cdecl;
    function obtemIdentificadorConfirmacaoTransacao: JString; cdecl;
    function obtemIdentificadorEstabelecimento: JString; cdecl;
    function obtemIdentificadorPontoCaptura: JString; cdecl;
    function obtemIdentificadorTransacaoAutomacao: JString; cdecl;
    function obtemInformacaoConfirmacao: Boolean; cdecl;
    function obtemMensagemResultado: JString; cdecl;
    function obtemModalidadePagamento: JModalidadesPagamento; cdecl;
    function obtemModalidadeTransacao: JModalidadesTransacao; cdecl;
    function obtemModoEntradaCartao: JString; cdecl;
    function obtemModoVerificacaoSenha: JString; cdecl;
    function obtemNomeCartao: JString; cdecl;
    function obtemNomeCartaoPadrao: JString; cdecl;
    function obtemNomeEstabelecimento: JString; cdecl;
    function obtemNomePortadorCartao: JString; cdecl;
    function obtemNomeProvedor: JString; cdecl;
    function obtemNsuHost: JString; cdecl;
    function obtemNsuHostOriginal: JString; cdecl;
    function obtemNsuLocal: JString; cdecl;
    function obtemNsuLocalOriginal: JString; cdecl;
    function obtemNumeroParcelas: Integer; cdecl;
    function obtemOperacao: JOperacoes; cdecl;
    function obtemPanMascarado: JString; cdecl;
    function obtemPanMascaradoPadrao: JString; cdecl;
    function obtemProvedor: JProvedores; cdecl;
    function obtemResultadoTransacao: Integer; cdecl;
    function obtemSaldoVoucher: JString; cdecl;
    function obtemTipoCartao: JCartoes; cdecl;
    function obtemTipoFinanciamento: JFinanciamentos; cdecl;
    function obtemUniqueID: JString; cdecl;
    function obtemValorDesconto: JString; cdecl;
    function obtemValorDevido: JString; cdecl;
    function obtemValorOriginal: JString; cdecl;
    function obtemValorTotal: JString; cdecl;
    function obtemValorTroco: JString; cdecl;
    function obtemViasImprimir: JViasImpressao; cdecl;
  end;
  TJSaidaTransacao = class(TJavaGenericImport<JSaidaTransacaoClass, JSaidaTransacao>) end;

  JSenderActivityClass = interface(JActivityClass)
    ['{2E893B51-D220-438B-97B1-8F2FECFD5E46}']
    {class} function init: JSenderActivity; cdecl;
    {class} function obtemDadosTransacao: JSaidaTransacao; cdecl;
    {class} function obtemVersoes: JVersoes; cdecl;
    {class} function saidaDisponivel: Boolean; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/SenderActivity')]
  JSenderActivity = interface(JActivity)
    ['{92DD3859-612F-410B-8183-F4C5D6311E69}']
    procedure onActivityResult(i: Integer; i1: Integer; intent: JIntent); cdecl;
  end;
  TJSenderActivity = class(TJavaGenericImport<JSenderActivityClass, JSenderActivity>) end;

  JStatusTransacaoClass = interface(JEnumClass)
    ['{966496CD-4A5D-43E3-81E9-7BEBBAF7C9CB}']
    {class} function _GetCONFIRMADO_AUTOMATICO: JStatusTransacao; cdecl;
    {class} function _GetCONFIRMADO_MANUAL: JStatusTransacao; cdecl;
    {class} function _GetDESFEITO_ERRO_IMPRESSAO_AUTOMATICO: JStatusTransacao; cdecl;
    {class} function _GetDESFEITO_LIBERACAO_MERCADORIA: JStatusTransacao; cdecl;
    {class} function _GetDESFEITO_MANUAL: JStatusTransacao; cdecl;
    {class} function _GetSTATUS_TRANSACAO_NAO_DEFINIDO: JStatusTransacao; cdecl;
    {class} function valueOf(string_: JString): JStatusTransacao; cdecl;
    {class} function values: TJavaObjectArray<JStatusTransacao>; cdecl;//Deprecated
    {class} property CONFIRMADO_AUTOMATICO: JStatusTransacao read _GetCONFIRMADO_AUTOMATICO;
    {class} property CONFIRMADO_MANUAL: JStatusTransacao read _GetCONFIRMADO_MANUAL;
    {class} property DESFEITO_ERRO_IMPRESSAO_AUTOMATICO: JStatusTransacao read _GetDESFEITO_ERRO_IMPRESSAO_AUTOMATICO;
    {class} property DESFEITO_LIBERACAO_MERCADORIA: JStatusTransacao read _GetDESFEITO_LIBERACAO_MERCADORIA;
    {class} property DESFEITO_MANUAL: JStatusTransacao read _GetDESFEITO_MANUAL;
    {class} property STATUS_TRANSACAO_NAO_DEFINIDO: JStatusTransacao read _GetSTATUS_TRANSACAO_NAO_DEFINIDO;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/StatusTransacao')]
  JStatusTransacao = interface(JEnum)
    ['{412EA77B-055D-43BC-A076-E795432AC0EF}']
  end;
  TJStatusTransacao = class(TJavaGenericImport<JStatusTransacaoClass, JStatusTransacao>) end;

  JTerminalClass = interface(JObjectClass)
    ['{C495225A-F6FD-4391-A478-450D014C39DD}']
    {class} function init: JTerminal; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Terminal')]
  JTerminal = interface(JObject)
    ['{A401B1D9-32D5-4322-A6A0-AC4C90916028}']
    function obtemEnderecoMAC: JString; cdecl;
    function obtemModeloTerminal: JString; cdecl;
    function obtemNumeroSerie: JString; cdecl;
    function obtemVersaoAplicacaoTerminal: JString; cdecl;
  end;
  TJTerminal = class(TJavaGenericImport<JTerminalClass, JTerminal>) end;

  JTerminalDesconectadoExcecaoClass = interface(JExceptionClass)
    ['{8B806AFD-968E-4784-B215-35AF534B01C2}']
    {class} function init: JTerminalDesconectadoExcecao; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/TerminalDesconectadoExcecao')]
  JTerminalDesconectadoExcecao = interface(JException)
    ['{AA3A63EB-3DC0-46E3-B3CC-181EED7C9D78}']
  end;
  TJTerminalDesconectadoExcecao = class(TJavaGenericImport<JTerminalDesconectadoExcecaoClass, JTerminalDesconectadoExcecao>) end;

  JTerminalNaoConfiguradoExcecaoClass = interface(JExceptionClass)
    ['{D569DE09-3918-4756-8CD9-54F496651819}']
    {class} function init: JTerminalNaoConfiguradoExcecao; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/TerminalNaoConfiguradoExcecao')]
  JTerminalNaoConfiguradoExcecao = interface(JException)
    ['{3CD1D677-5662-4752-81E6-DEC0D86D7714}']
  end;
  TJTerminalNaoConfiguradoExcecao = class(TJavaGenericImport<JTerminalNaoConfiguradoExcecaoClass, JTerminalNaoConfiguradoExcecao>) end;

  JTransacaoClass = interface(IJavaClass)
    ['{09899C77-27BB-40BD-867C-473813A31431}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Transacao')]
  JTransacao = interface(IJavaInstance)
    ['{19C124C7-71C4-47D4-8021-B7DFF6452650}']
    procedure confirmaTransacao(confirmacao: JConfirmacao); cdecl;
    function realizaTransacao(entradaTransacao: JEntradaTransacao): JSaidaTransacao; cdecl;
    procedure resolvePendencia(transacaoPendenteDados: JTransacaoPendenteDados; confirmacao: JConfirmacao); cdecl;
  end;
  TJTransacao = class(TJavaGenericImport<JTransacaoClass, JTransacao>) end;

  JTransacaoPendenteDadosClass = interface(JSerializableClass)
    ['{778C5890-14CE-4A6A-B253-0E886CF656B5}']
    {class} function init: JTransacaoPendenteDados; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/TransacaoPendenteDados')]
  JTransacaoPendenteDados = interface(JSerializable)
    ['{2BCF587C-7FB8-4F43-A615-096C17324B16}']
    procedure informaIdentificadorEstabelecimento(string_: JString); cdecl;
    procedure informaNomeProvedor(string_: JString); cdecl;
    procedure informaNsuHost(string_: JString); cdecl;
    procedure informaNsuLocal(string_: JString); cdecl;
    procedure informaNsuTransacao(string_: JString); cdecl;
    procedure informaProvedor(provedores: JProvedores); cdecl;
    function obtemIdentificadorEstabelecimento: JString; cdecl;
    function obtemNomeProvedor: JString; cdecl;
    function obtemNsuHost: JString; cdecl;
    function obtemNsuLocal: JString; cdecl;
    function obtemNsuTransacao: JString; cdecl;
    function obtemProvedor: JProvedores; cdecl;
    function toString: JString; cdecl;
  end;
  TJTransacaoPendenteDados = class(TJavaGenericImport<JTransacaoPendenteDadosClass, JTransacaoPendenteDados>) end;

  JTransacoesClass = interface(JTransacaoClass)
    ['{3D91E347-EC7C-41D0-9235-04F0B85D4FF3}']
    {class} function obtemInstancia(dadosAutomacao: JDadosAutomacao; context: JContext): JTransacoes; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Transacoes')]
  JTransacoes = interface(JTransacao)
    ['{49FA260A-24A3-42F5-A7DA-A4A9593F8D24}']
    procedure confirmaTransacao(confirmacao: JConfirmacao); cdecl;
    function obtemVersoes: JVersoes; cdecl;
    function realizaTransacao(entradaTransacao: JEntradaTransacao): JSaidaTransacao; cdecl;
    procedure resolvePendencia(transacaoPendenteDados: JTransacaoPendenteDados; confirmacao: JConfirmacao); cdecl;
  end;
  TJTransacoes = class(TJavaGenericImport<JTransacoesClass, JTransacoes>) end;

  JTransacoes_1Class = interface(JObjectClass)
    ['{28993252-5FAB-4DB7-9345-3DE011E392C7}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Transacoes$1')]
  JTransacoes_1 = interface(JObject)
    ['{6B6B9BB5-CA83-4EFE-8853-F13E5965E3E9}']
  end;
  TJTransacoes_1 = class(TJavaGenericImport<JTransacoes_1Class, JTransacoes_1>) end;

  JTransacoes_TransacaoResultReceiverClass = interface(JResultReceiverClass)
    ['{FE74E9E8-D7B6-4F29-BB49-8D89314A4493}']
    {class} function init(transacoes: JTransacoes; handler: JHandler; 1: JTransacoes_1): JTransacoes_TransacaoResultReceiver; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Transacoes$TransacaoResultReceiver')]
  JTransacoes_TransacaoResultReceiver = interface(JResultReceiver)
    ['{1D70731D-A685-479C-BEF7-9C923B7A6249}']
    procedure onReceiveResult(i: Integer; bundle: JBundle); cdecl;
  end;
  TJTransacoes_TransacaoResultReceiver = class(TJavaGenericImport<JTransacoes_TransacaoResultReceiverClass, JTransacoes_TransacaoResultReceiver>) end;

  JVersoesClass = interface(JObjectClass)
    ['{5669BA25-7B85-4783-BA52-F4C7D8125F39}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/Versoes')]
  JVersoes = interface(JObject)
    ['{E1CAFFF3-9656-48E4-AD4F-AC5BA05B0D0A}']
    procedure informaVersaoBiblioteca(string_: JString); cdecl;
    function obtemVersaoApk: JMap; cdecl;
    function obtemVersaoBiblioteca: JString; cdecl;
  end;
  TJVersoes = class(TJavaGenericImport<JVersoesClass, JVersoes>) end;

  JViasImpressaoClass = interface(JEnumClass)
    ['{DE82BB22-D57D-4523-B06B-96A1CD90B0B9}']
    {class} function _GetVIA_CLIENTE: JViasImpressao; cdecl;
    {class} function _GetVIA_CLIENTE_E_ESTABELECIMENTO: JViasImpressao; cdecl;
    {class} function _GetVIA_ESTABELECIMENTO: JViasImpressao; cdecl;
    {class} function _GetVIA_NENHUMA: JViasImpressao; cdecl;
    {class} function obtemViaImpressao(i: Integer): JViasImpressao; cdecl;
    {class} function valueOf(string_: JString): JViasImpressao; cdecl;
    {class} function values: TJavaObjectArray<JViasImpressao>; cdecl;//Deprecated
    {class} property VIA_CLIENTE: JViasImpressao read _GetVIA_CLIENTE;
    {class} property VIA_CLIENTE_E_ESTABELECIMENTO: JViasImpressao read _GetVIA_CLIENTE_E_ESTABELECIMENTO;
    {class} property VIA_ESTABELECIMENTO: JViasImpressao read _GetVIA_ESTABELECIMENTO;
    {class} property VIA_NENHUMA: JViasImpressao read _GetVIA_NENHUMA;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/ViasImpressao')]
  JViasImpressao = interface(JEnum)
    ['{C704E429-389E-4D50-AA20-9469A7EEA2D4}']
    function obtemTipoViaImpressao: Integer; cdecl;
  end;
  TJViasImpressao = class(TJavaGenericImport<JViasImpressaoClass, JViasImpressao>) end;

  JCustomizationClass = interface(IJavaClass)
    ['{15A28D37-C44D-4589-B7F0-82DE01BF3FD9}']
    {class} function _GetEDITBOX_BACKGROUND_COLOR: JString; cdecl;
    {class} function _GetEDITBOX_COLOR_TEXT: JString; cdecl;
    {class} function _GetFONT: JString; cdecl;
    {class} function _GetFONT_COLOR: JString; cdecl;
    {class} function _GetKEYBOARD_BACKGROUND_COLOR: JString; cdecl;
    {class} function _GetKEYBOARD_FONT_COLOR: JString; cdecl;
    {class} function _GetMENU_SEPARATOR_COLOR: JString; cdecl;
    {class} function _GetPRESSED_KEY_COLOR: JString; cdecl;
    {class} function _GetRELEASED_KEY_COLOR: JString; cdecl;
    {class} function _GetSCREEN_BACKGROUND_COLOR: JString; cdecl;
    {class} function _GetTOOLBAR_BACKGROUND: JString; cdecl;
    {class} function _GetTOOLBAR_ICON: JString; cdecl;
    {class} property EDITBOX_BACKGROUND_COLOR: JString read _GetEDITBOX_BACKGROUND_COLOR;
    {class} property EDITBOX_COLOR_TEXT: JString read _GetEDITBOX_COLOR_TEXT;
    {class} property FONT: JString read _GetFONT;
    {class} property FONT_COLOR: JString read _GetFONT_COLOR;
    {class} property KEYBOARD_BACKGROUND_COLOR: JString read _GetKEYBOARD_BACKGROUND_COLOR;
    {class} property KEYBOARD_FONT_COLOR: JString read _GetKEYBOARD_FONT_COLOR;
    {class} property MENU_SEPARATOR_COLOR: JString read _GetMENU_SEPARATOR_COLOR;
    {class} property PRESSED_KEY_COLOR: JString read _GetPRESSED_KEY_COLOR;
    {class} property RELEASED_KEY_COLOR: JString read _GetRELEASED_KEY_COLOR;
    {class} property SCREEN_BACKGROUND_COLOR: JString read _GetSCREEN_BACKGROUND_COLOR;
    {class} property TOOLBAR_BACKGROUND: JString read _GetTOOLBAR_BACKGROUND;
    {class} property TOOLBAR_ICON: JString read _GetTOOLBAR_ICON;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/espec/Customization')]
  JCustomization = interface(IJavaInstance)
    ['{F384495A-45EE-4842-9D93-5566100862CD}']
  end;
  TJCustomization = class(TJavaGenericImport<JCustomizationClass, JCustomization>) end;

  JTransactionInputClass = interface(IJavaClass)
    ['{E5C25545-F95E-4D8A-8B7A-6272F4BB06AD}']
    {class} function _GetACQUIRER: JString; cdecl;
    {class} function _GetADD_POSDATA1: JString; cdecl;
    {class} function _GetADD_POSDATA2: JString; cdecl;
    {class} function _GetADD_POSDATA3: JString; cdecl;
    {class} function _GetADD_POSDATA4: JString; cdecl;
    {class} function _GetAMOUNT: JString; cdecl;
    {class} function _GetBOARDING_TAX: JString; cdecl;
    {class} function _GetCARD_TYPE: JString; cdecl;
    {class} function _GetCURRENCY_CODE: JString; cdecl;
    {class} function _GetFIN_TYPE: JString; cdecl;
    {class} function _GetFISCAL_DOC: JString; cdecl;
    {class} function _GetINPUT: JString; cdecl;
    {class} function _GetINSTALLMENTS: JString; cdecl;
    {class} function _GetINVOICE_NUMBER: JString; cdecl;
    {class} function _GetOPERATION: JString; cdecl;
    {class} function _GetORIG_AUTHCODE: JString; cdecl;
    {class} function _GetORIG_DATETIME: JString; cdecl;
    {class} function _GetORIG_NSU: JString; cdecl;
    {class} function _GetPAY_MODE: JString; cdecl;
    {class} function _GetPOSTDATED_DATE: JString; cdecl;
    {class} function _GetPOS_ID: JString; cdecl;
    {class} function _GetSERVICE_TAX: JString; cdecl;
    {class} function _GetTAX_ID: JString; cdecl;
    {class} function _GetTEL_NUMBER: JString; cdecl;
    {class} property ACQUIRER: JString read _GetACQUIRER;
    {class} property ADD_POSDATA1: JString read _GetADD_POSDATA1;
    {class} property ADD_POSDATA2: JString read _GetADD_POSDATA2;
    {class} property ADD_POSDATA3: JString read _GetADD_POSDATA3;
    {class} property ADD_POSDATA4: JString read _GetADD_POSDATA4;
    {class} property AMOUNT: JString read _GetAMOUNT;
    {class} property BOARDING_TAX: JString read _GetBOARDING_TAX;
    {class} property CARD_TYPE: JString read _GetCARD_TYPE;
    {class} property CURRENCY_CODE: JString read _GetCURRENCY_CODE;
    {class} property FIN_TYPE: JString read _GetFIN_TYPE;
    {class} property FISCAL_DOC: JString read _GetFISCAL_DOC;
    {class} property INPUT: JString read _GetINPUT;
    {class} property INSTALLMENTS: JString read _GetINSTALLMENTS;
    {class} property INVOICE_NUMBER: JString read _GetINVOICE_NUMBER;
    {class} property OPERATION: JString read _GetOPERATION;
    {class} property ORIG_AUTHCODE: JString read _GetORIG_AUTHCODE;
    {class} property ORIG_DATETIME: JString read _GetORIG_DATETIME;
    {class} property ORIG_NSU: JString read _GetORIG_NSU;
    {class} property PAY_MODE: JString read _GetPAY_MODE;
    {class} property POSTDATED_DATE: JString read _GetPOSTDATED_DATE;
    {class} property POS_ID: JString read _GetPOS_ID;
    {class} property SERVICE_TAX: JString read _GetSERVICE_TAX;
    {class} property TAX_ID: JString read _GetTAX_ID;
    {class} property TEL_NUMBER: JString read _GetTEL_NUMBER;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/espec/TransactionInput')]
  JTransactionInput = interface(IJavaInstance)
    ['{6B12DFDB-6020-4E03-8FAF-FFA141EC1092}']
  end;
  TJTransactionInput = class(TJavaGenericImport<JTransactionInputClass, JTransactionInput>) end;

  JTransactionOutputClass = interface(IJavaClass)
    ['{1C2F6006-6451-4B90-9E58-A53EF9BBB782}']
    {class} function _GetAMOUNT: JString; cdecl;
    {class} function _GetAUTHORIZATION_CODE: JString; cdecl;
    {class} function _GetBALANCE_VOUCHER: JString; cdecl;
    {class} function _GetCARD_AID: JString; cdecl;
    {class} function _GetCARD_ENTRANCE_MODE: JString; cdecl;
    {class} function _GetCARD_HOLDER_NAME: JString; cdecl;
    {class} function _GetCARD_NAME: JString; cdecl;
    {class} function _GetCARD_TYPE: JString; cdecl;
    {class} function _GetCHANGE: JString; cdecl;
    {class} function _GetCONFIRM_TRANSACTION_IDENTIFIER: JString; cdecl;
    {class} function _GetCURRENCY_CODE: JString; cdecl;
    {class} function _GetDATE_TIME_ORIGINAL_TRANSACTION: JString; cdecl;
    {class} function _GetDATE_TIME_TRANSACTION: JString; cdecl;
    {class} function _GetDIFFERENTIATED_HOLDER_VOUCHER: JString; cdecl;
    {class} function _GetDIFFERENTIATED_SHOP_VOUCHER: JString; cdecl;
    {class} function _GetDISCOUNT: JString; cdecl;
    {class} function _GetDUE_AMOUNT: JString; cdecl;
    {class} function _GetESTABLISHMENT_IDENTIFIER: JString; cdecl;
    {class} function _GetESTABLISHMENT_NAME: JString; cdecl;
    {class} function _GetFINANCING_TYPE: JString; cdecl;
    {class} function _GetFISCAL_DOCUMENT: JString; cdecl;
    {class} function _GetFULL_VOUCHER: JString; cdecl;
    {class} function _GetGRAPHIC_RECEIPT_EXISTS: JString; cdecl;
    {class} function _GetHOLDER_GRAPHIC_RECEIPT: JString; cdecl;
    {class} function _GetMASKED_PAN: JString; cdecl;
    {class} function _GetNETWORK_RESPONSE: JString; cdecl;
    {class} function _GetNSU_ORIGINAL_TRANSACTION: JString; cdecl;
    {class} function _GetNUMBER_OF_INSTALLMENTS: JString; cdecl;
    {class} function _GetONOFF: JString; cdecl;
    {class} function _GetOPERATION: JString; cdecl;
    {class} function _GetORIGINAL_AUTHORIZATION_CODE: JString; cdecl;
    {class} function _GetORIGINAL_TERMINAL_NSU: JString; cdecl;
    {class} function _GetORIGINAL_VALUE: JString; cdecl;
    {class} function _GetOUTPUT: JString; cdecl;
    {class} function _GetPASSWORD_VERIFICATION_MODE: JString; cdecl;
    {class} function _GetPAY_MODE: JString; cdecl;
    {class} function _GetPENDING_TRANSACTION_DATA: JString; cdecl;
    {class} function _GetPENDING_TRANSACTION_EXISTS: JString; cdecl;
    {class} function _GetPOINT_OF_SALE_IDENTIFIER: JString; cdecl;
    {class} function _GetPREDATED_DATE: JString; cdecl;
    {class} function _GetPRINT_RECEIPTS: JString; cdecl;
    {class} function _GetPROVIDER: JString; cdecl;
    {class} function _GetPROVIDER_NAME: JString; cdecl;
    {class} function _GetREDUCED_HOLDER_VOUCHER: JString; cdecl;
    {class} function _GetREQUIRES_CONFIRMATION: JString; cdecl;
    {class} function _GetRESULT_MESSAGE: JString; cdecl;
    {class} function _GetSTANDARD_CARD_NAME: JString; cdecl;
    {class} function _GetSTANDARD_MASKED_PAN: JString; cdecl;
    {class} function _GetSTORE_KEEPER_GRAPHIC_RECEIPT: JString; cdecl;
    {class} function _GetTERMINAL_NSU: JString; cdecl;
    {class} function _GetTRANSACTION_IDENTIFIER: JString; cdecl;
    {class} function _GetTRANSACTION_NSU: JString; cdecl;
    {class} function _GetTRANSACTION_RESULT: JString; cdecl;
    {class} function _GetUNIQUE_ID: JString; cdecl;
    {class} function _GetWALLET_USER_ID: JString; cdecl;
    {class} property AMOUNT: JString read _GetAMOUNT;
    {class} property AUTHORIZATION_CODE: JString read _GetAUTHORIZATION_CODE;
    {class} property BALANCE_VOUCHER: JString read _GetBALANCE_VOUCHER;
    {class} property CARD_AID: JString read _GetCARD_AID;
    {class} property CARD_ENTRANCE_MODE: JString read _GetCARD_ENTRANCE_MODE;
    {class} property CARD_HOLDER_NAME: JString read _GetCARD_HOLDER_NAME;
    {class} property CARD_NAME: JString read _GetCARD_NAME;
    {class} property CARD_TYPE: JString read _GetCARD_TYPE;
    {class} property CHANGE: JString read _GetCHANGE;
    {class} property CONFIRM_TRANSACTION_IDENTIFIER: JString read _GetCONFIRM_TRANSACTION_IDENTIFIER;
    {class} property CURRENCY_CODE: JString read _GetCURRENCY_CODE;
    {class} property DATE_TIME_ORIGINAL_TRANSACTION: JString read _GetDATE_TIME_ORIGINAL_TRANSACTION;
    {class} property DATE_TIME_TRANSACTION: JString read _GetDATE_TIME_TRANSACTION;
    {class} property DIFFERENTIATED_HOLDER_VOUCHER: JString read _GetDIFFERENTIATED_HOLDER_VOUCHER;
    {class} property DIFFERENTIATED_SHOP_VOUCHER: JString read _GetDIFFERENTIATED_SHOP_VOUCHER;
    {class} property DISCOUNT: JString read _GetDISCOUNT;
    {class} property DUE_AMOUNT: JString read _GetDUE_AMOUNT;
    {class} property ESTABLISHMENT_IDENTIFIER: JString read _GetESTABLISHMENT_IDENTIFIER;
    {class} property ESTABLISHMENT_NAME: JString read _GetESTABLISHMENT_NAME;
    {class} property FINANCING_TYPE: JString read _GetFINANCING_TYPE;
    {class} property FISCAL_DOCUMENT: JString read _GetFISCAL_DOCUMENT;
    {class} property FULL_VOUCHER: JString read _GetFULL_VOUCHER;
    {class} property GRAPHIC_RECEIPT_EXISTS: JString read _GetGRAPHIC_RECEIPT_EXISTS;
    {class} property HOLDER_GRAPHIC_RECEIPT: JString read _GetHOLDER_GRAPHIC_RECEIPT;
    {class} property MASKED_PAN: JString read _GetMASKED_PAN;
    {class} property NETWORK_RESPONSE: JString read _GetNETWORK_RESPONSE;
    {class} property NSU_ORIGINAL_TRANSACTION: JString read _GetNSU_ORIGINAL_TRANSACTION;
    {class} property NUMBER_OF_INSTALLMENTS: JString read _GetNUMBER_OF_INSTALLMENTS;
    {class} property ONOFF: JString read _GetONOFF;
    {class} property OPERATION: JString read _GetOPERATION;
    {class} property ORIGINAL_AUTHORIZATION_CODE: JString read _GetORIGINAL_AUTHORIZATION_CODE;
    {class} property ORIGINAL_TERMINAL_NSU: JString read _GetORIGINAL_TERMINAL_NSU;
    {class} property ORIGINAL_VALUE: JString read _GetORIGINAL_VALUE;
    {class} property OUTPUT: JString read _GetOUTPUT;
    {class} property PASSWORD_VERIFICATION_MODE: JString read _GetPASSWORD_VERIFICATION_MODE;
    {class} property PAY_MODE: JString read _GetPAY_MODE;
    {class} property PENDING_TRANSACTION_DATA: JString read _GetPENDING_TRANSACTION_DATA;
    {class} property PENDING_TRANSACTION_EXISTS: JString read _GetPENDING_TRANSACTION_EXISTS;
    {class} property POINT_OF_SALE_IDENTIFIER: JString read _GetPOINT_OF_SALE_IDENTIFIER;
    {class} property PREDATED_DATE: JString read _GetPREDATED_DATE;
    {class} property PRINT_RECEIPTS: JString read _GetPRINT_RECEIPTS;
    {class} property PROVIDER: JString read _GetPROVIDER;
    {class} property PROVIDER_NAME: JString read _GetPROVIDER_NAME;
    {class} property REDUCED_HOLDER_VOUCHER: JString read _GetREDUCED_HOLDER_VOUCHER;
    {class} property REQUIRES_CONFIRMATION: JString read _GetREQUIRES_CONFIRMATION;
    {class} property RESULT_MESSAGE: JString read _GetRESULT_MESSAGE;
    {class} property STANDARD_CARD_NAME: JString read _GetSTANDARD_CARD_NAME;
    {class} property STANDARD_MASKED_PAN: JString read _GetSTANDARD_MASKED_PAN;
    {class} property STORE_KEEPER_GRAPHIC_RECEIPT: JString read _GetSTORE_KEEPER_GRAPHIC_RECEIPT;
    {class} property TERMINAL_NSU: JString read _GetTERMINAL_NSU;
    {class} property TRANSACTION_IDENTIFIER: JString read _GetTRANSACTION_IDENTIFIER;
    {class} property TRANSACTION_NSU: JString read _GetTRANSACTION_NSU;
    {class} property TRANSACTION_RESULT: JString read _GetTRANSACTION_RESULT;
    {class} property UNIQUE_ID: JString read _GetUNIQUE_ID;
    {class} property WALLET_USER_ID: JString read _GetWALLET_USER_ID;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/espec/TransactionOutput')]
  JTransactionOutput = interface(IJavaInstance)
    ['{6759D66F-0382-4516-B319-C6DE6E2BF0D7}']
  end;
  TJTransactionOutput = class(TJavaGenericImport<JTransactionOutputClass, JTransactionOutput>) end;

  JDateParserClass = interface(JObjectClass)
    ['{6B9EE35D-B2C0-4B24-90BD-4282AD0ED01A}']
    {class} function date2String(date: JDate): JString; cdecl;
    {class} function init: JDateParser; cdecl;
    {class} function string2Date(string_: JString): JDate; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/DateParser')]
  JDateParser = interface(JObject)
    ['{548384B0-9501-4B2F-9D41-76A94FCD2C4C}']
  end;
  TJDateParser = class(TJavaGenericImport<JDateParserClass, JDateParser>) end;

  JEnumTypeClass = interface(JObjectClass)
    ['{F4768B0F-A4F6-425D-B0BF-BAAAD096633F}']
    {class} function _GetTYPE_NAME: Integer; cdecl;
    {class} function _GetTYPE_ORDINAL: Integer; cdecl;
    {class} function _GetTYPE_VALUE: Integer; cdecl;
    {class} function init: JEnumType; cdecl;//Deprecated
    {class} property TYPE_NAME: Integer read _GetTYPE_NAME;
    {class} property TYPE_ORDINAL: Integer read _GetTYPE_ORDINAL;
    {class} property TYPE_VALUE: Integer read _GetTYPE_VALUE;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/EnumType')]
  JEnumType = interface(JObject)
    ['{86DE034D-8EB5-44F5-80B6-A0822B26A2C2}']
  end;
  TJEnumType = class(TJavaGenericImport<JEnumTypeClass, JEnumType>) end;

  JInputParserClass = interface(JObjectClass)
    ['{9A307D08-3DE2-4A07-B0D9-4997A235EF9B}']
    {class} function init(string_: JString; string_1: JString): JInputParser; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/InputParser')]
  JInputParser = interface(JObject)
    ['{9517D90A-4540-4BC0-A29A-41D26DDDFE36}']
    procedure addObject(object_: JObject); cdecl;
    procedure addParameter(string_: JString; string_1: JString); cdecl;
    procedure addPath(string_: JString); cdecl;
    function toString: JString; cdecl;
  end;
  TJInputParser = class(TJavaGenericImport<JInputParserClass, JInputParser>) end;

  JOutputParserClass = interface(JObjectClass)
    ['{3E1BFA1D-CF65-44B1-B8D5-F732690F7219}']
    {class} function init(string_: JString): JOutputParser; cdecl;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/OutputParser')]
  JOutputParser = interface(JObject)
    ['{C404BA50-79E0-4A10-ABF5-8803EDCA72D6}']
    function getObject(class_: Jlang_Class): JObject; cdecl; overload;
    function getObject(class_: Jlang_Class; object_: JObject): JObject; cdecl; overload;
  end;
  TJOutputParser = class(TJavaGenericImport<JOutputParserClass, JOutputParser>) end;

  Jparser_ParseExceptionClass = interface(JExceptionClass)
    ['{14267AFA-0580-4D02-A848-ECAE85B35540}']
    {class} function init: Jparser_ParseException; cdecl; overload;
    {class} function init(throwable: JThrowable): Jparser_ParseException; cdecl; overload;
    {class} function init(string_: JString): Jparser_ParseException; cdecl; overload;
    {class} function init(string_: JString; throwable: JThrowable): Jparser_ParseException; cdecl; overload;
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/ParseException')]
  Jparser_ParseException = interface(JException)
    ['{A139E62F-0A3E-485E-9BAF-E23ED1DFB114}']
  end;
  TJparser_ParseException = class(TJavaGenericImport<Jparser_ParseExceptionClass, Jparser_ParseException>) end;

  JUriArrayFieldNameClass = interface(JAnnotationClass)
    ['{57CD74DB-56DD-4722-8A39-8AC3F9F9D4BA}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/UriArrayFieldName')]
  JUriArrayFieldName = interface(JAnnotation)
    ['{5FB042AE-1B74-41B1-BAB8-CB86F9CE297E}']
    function value: JString; cdecl;
  end;
  TJUriArrayFieldName = class(TJavaGenericImport<JUriArrayFieldNameClass, JUriArrayFieldName>) end;

  Jparser_UriClassClass = interface(JAnnotationClass)
    ['{216AD816-1131-42A8-8368-1FE301E34957}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/UriClass')]
  Jparser_UriClass = interface(JAnnotation)
    ['{52D40B14-C6B4-4D4B-B260-2ADB1370392D}']
    function value: JString; cdecl;
  end;
  TJparser_UriClass = class(TJavaGenericImport<Jparser_UriClassClass, Jparser_UriClass>) end;

  JUriCustomizeFieldNameClass = interface(JAnnotationClass)
    ['{3F6A4957-F019-43F4-8961-6CEF8A1046C6}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/UriCustomizeFieldName')]
  JUriCustomizeFieldName = interface(JAnnotation)
    ['{3F236A8D-737E-4B89-B492-8E17A4B54220}']
    function value: JString; cdecl;
  end;
  TJUriCustomizeFieldName = class(TJavaGenericImport<JUriCustomizeFieldNameClass, JUriCustomizeFieldName>) end;

  JUriDateFieldNameClass = interface(JAnnotationClass)
    ['{99FE3321-9EC6-46D0-8356-62311AA6A336}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/UriDateFieldName')]
  JUriDateFieldName = interface(JAnnotation)
    ['{4FA2D52F-2AE0-4DD4-B1D3-E60909F951DC}']
    function value: JString; cdecl;
  end;
  TJUriDateFieldName = class(TJavaGenericImport<JUriDateFieldNameClass, JUriDateFieldName>) end;

  JUriEnumFieldNameClass = interface(JAnnotationClass)
    ['{3BEEF383-A6F9-4749-8955-5BD9FACC6168}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/UriEnumFieldName')]
  JUriEnumFieldName = interface(JAnnotation)
    ['{9610F069-CED0-4029-90FE-DB1C76864F37}']
    function value: JString; cdecl;
  end;
  TJUriEnumFieldName = class(TJavaGenericImport<JUriEnumFieldNameClass, JUriEnumFieldName>) end;

  JUriFileFieldNameClass = interface(JAnnotationClass)
    ['{7A41F3C5-C554-438A-A748-0889F5589703}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/UriFileFieldName')]
  JUriFileFieldName = interface(JAnnotation)
    ['{E417696A-540D-4F9C-8B35-C1250E633C8C}']
    function value: JString; cdecl;
  end;
  TJUriFileFieldName = class(TJavaGenericImport<JUriFileFieldNameClass, JUriFileFieldName>) end;

  JUriMethodNameClass = interface(JAnnotationClass)
    ['{D3774FDD-5AED-4CCE-9EC9-F8698EAB5404}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/UriMethodName')]
  JUriMethodName = interface(JAnnotation)
    ['{3DFA9E69-EB65-4A5B-93B7-A4BC067F87AD}']
    function json: TJavaObjectArray<Jparser_UriClass>; cdecl;
  end;
  TJUriMethodName = class(TJavaGenericImport<JUriMethodNameClass, JUriMethodName>) end;

  JUriObjectFieldNameClass = interface(JAnnotationClass)
    ['{DBCF4C3A-0FC8-4990-B76F-AB6C6503DB3F}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/UriObjectFieldName')]
  JUriObjectFieldName = interface(JAnnotation)
    ['{BD4250F4-701F-4E71-B751-0074BDE74D50}']
    function value: JString; cdecl;
  end;
  TJUriObjectFieldName = class(TJavaGenericImport<JUriObjectFieldNameClass, JUriObjectFieldName>) end;

  JUriPrimitiveFieldNameClass = interface(JAnnotationClass)
    ['{0CEB968F-81AD-4D76-AB58-0A870E98DA9C}']
  end;

  [JavaSignature('br/com/setis/interfaceautomacao/parser/UriPrimitiveFieldName')]
  JUriPrimitiveFieldName = interface(JAnnotation)
    ['{82C16D7D-5E29-41EB-AFC4-C9D8394A37A4}']
    function value: JString; cdecl;
  end;
  TJUriPrimitiveFieldName = class(TJavaGenericImport<JUriPrimitiveFieldNameClass, JUriPrimitiveFieldName>) end;

implementation

procedure RegisterTypes;
begin
  TRegTypes.RegisterType('Interface2.JAnimator', TypeInfo(Interface2.JAnimator));
  TRegTypes.RegisterType('Interface2.JAnimator_AnimatorListener', TypeInfo(Interface2.JAnimator_AnimatorListener));
  TRegTypes.RegisterType('Interface2.JAnimator_AnimatorPauseListener', TypeInfo(Interface2.JAnimator_AnimatorPauseListener));
  TRegTypes.RegisterType('Interface2.JKeyframe', TypeInfo(Interface2.JKeyframe));
  TRegTypes.RegisterType('Interface2.JLayoutTransition', TypeInfo(Interface2.JLayoutTransition));
  TRegTypes.RegisterType('Interface2.JLayoutTransition_TransitionListener', TypeInfo(Interface2.JLayoutTransition_TransitionListener));
  TRegTypes.RegisterType('Interface2.JPropertyValuesHolder', TypeInfo(Interface2.JPropertyValuesHolder));
  TRegTypes.RegisterType('Interface2.JStateListAnimator', TypeInfo(Interface2.JStateListAnimator));
  TRegTypes.RegisterType('Interface2.JTimeInterpolator', TypeInfo(Interface2.JTimeInterpolator));
  TRegTypes.RegisterType('Interface2.JTypeConverter', TypeInfo(Interface2.JTypeConverter));
  TRegTypes.RegisterType('Interface2.JTypeEvaluator', TypeInfo(Interface2.JTypeEvaluator));
  TRegTypes.RegisterType('Interface2.JValueAnimator', TypeInfo(Interface2.JValueAnimator));
  TRegTypes.RegisterType('Interface2.JValueAnimator_AnimatorUpdateListener', TypeInfo(Interface2.JValueAnimator_AnimatorUpdateListener));
  TRegTypes.RegisterType('Interface2.JPathMotion', TypeInfo(Interface2.JPathMotion));
  TRegTypes.RegisterType('Interface2.JScene', TypeInfo(Interface2.JScene));
  TRegTypes.RegisterType('Interface2.JTransition', TypeInfo(Interface2.JTransition));
  TRegTypes.RegisterType('Interface2.JTransition_EpicenterCallback', TypeInfo(Interface2.JTransition_EpicenterCallback));
  TRegTypes.RegisterType('Interface2.JTransition_TransitionListener', TypeInfo(Interface2.JTransition_TransitionListener));
  TRegTypes.RegisterType('Interface2.JTransitionManager', TypeInfo(Interface2.JTransitionManager));
  TRegTypes.RegisterType('Interface2.JTransitionPropagation', TypeInfo(Interface2.JTransitionPropagation));
  TRegTypes.RegisterType('Interface2.JTransitionValues', TypeInfo(Interface2.JTransitionValues));
  TRegTypes.RegisterType('Interface2.JInterpolator', TypeInfo(Interface2.JInterpolator));
  TRegTypes.RegisterType('Interface2.JToolbar_LayoutParams', TypeInfo(Interface2.JToolbar_LayoutParams));
  TRegTypes.RegisterType('Interface2.JAplicacaoNaoInstaladaExcecao', TypeInfo(Interface2.JAplicacaoNaoInstaladaExcecao));
  TRegTypes.RegisterType('Interface2.Jinterfaceautomacao_BuildConfig', TypeInfo(Interface2.Jinterfaceautomacao_BuildConfig));
  TRegTypes.RegisterType('Interface2.JCartoes', TypeInfo(Interface2.JCartoes));
  TRegTypes.RegisterType('Interface2.JComunicacaoServico', TypeInfo(Interface2.JComunicacaoServico));
  TRegTypes.RegisterType('Interface2.JComunicacaoServico_IncomingHandler', TypeInfo(Interface2.JComunicacaoServico_IncomingHandler));
  TRegTypes.RegisterType('Interface2.JConfirmacao', TypeInfo(Interface2.JConfirmacao));
  TRegTypes.RegisterType('Interface2.JConfirmacoes', TypeInfo(Interface2.JConfirmacoes));
  TRegTypes.RegisterType('Interface2.JDadosAutomacao', TypeInfo(Interface2.JDadosAutomacao));
  TRegTypes.RegisterType('Interface2.JEntradaTransacao', TypeInfo(Interface2.JEntradaTransacao));
  TRegTypes.RegisterType('Interface2.JFinanciamentos', TypeInfo(Interface2.JFinanciamentos));
  TRegTypes.RegisterType('Interface2.JGlobalDefs', TypeInfo(Interface2.JGlobalDefs));
  TRegTypes.RegisterType('Interface2.JIdentificacaoPortadorCarteira', TypeInfo(Interface2.JIdentificacaoPortadorCarteira));
  TRegTypes.RegisterType('Interface2.JModalidadesPagamento', TypeInfo(Interface2.JModalidadesPagamento));
  TRegTypes.RegisterType('Interface2.JModalidadesTransacao', TypeInfo(Interface2.JModalidadesTransacao));
  TRegTypes.RegisterType('Interface2.JOperacoes', TypeInfo(Interface2.JOperacoes));
  TRegTypes.RegisterType('Interface2.JPersonalizacao', TypeInfo(Interface2.JPersonalizacao));
  TRegTypes.RegisterType('Interface2.JPersonalizacao_1', TypeInfo(Interface2.JPersonalizacao_1));
  TRegTypes.RegisterType('Interface2.JPersonalizacao_Builder', TypeInfo(Interface2.JPersonalizacao_Builder));
  TRegTypes.RegisterType('Interface2.JProvedores', TypeInfo(Interface2.JProvedores));
  TRegTypes.RegisterType('Interface2.JQuedaConexaoTerminalExcecao', TypeInfo(Interface2.JQuedaConexaoTerminalExcecao));
  TRegTypes.RegisterType('Interface2.JSaidaTransacao', TypeInfo(Interface2.JSaidaTransacao));
  TRegTypes.RegisterType('Interface2.JSenderActivity', TypeInfo(Interface2.JSenderActivity));
  TRegTypes.RegisterType('Interface2.JStatusTransacao', TypeInfo(Interface2.JStatusTransacao));
  TRegTypes.RegisterType('Interface2.JTerminal', TypeInfo(Interface2.JTerminal));
  TRegTypes.RegisterType('Interface2.JTerminalDesconectadoExcecao', TypeInfo(Interface2.JTerminalDesconectadoExcecao));
  TRegTypes.RegisterType('Interface2.JTerminalNaoConfiguradoExcecao', TypeInfo(Interface2.JTerminalNaoConfiguradoExcecao));
  TRegTypes.RegisterType('Interface2.JTransacao', TypeInfo(Interface2.JTransacao));
  TRegTypes.RegisterType('Interface2.JTransacaoPendenteDados', TypeInfo(Interface2.JTransacaoPendenteDados));
  TRegTypes.RegisterType('Interface2.JTransacoes', TypeInfo(Interface2.JTransacoes));
  TRegTypes.RegisterType('Interface2.JTransacoes_1', TypeInfo(Interface2.JTransacoes_1));
  TRegTypes.RegisterType('Interface2.JTransacoes_TransacaoResultReceiver', TypeInfo(Interface2.JTransacoes_TransacaoResultReceiver));
  TRegTypes.RegisterType('Interface2.JVersoes', TypeInfo(Interface2.JVersoes));
  TRegTypes.RegisterType('Interface2.JViasImpressao', TypeInfo(Interface2.JViasImpressao));
  TRegTypes.RegisterType('Interface2.JCustomization', TypeInfo(Interface2.JCustomization));
  TRegTypes.RegisterType('Interface2.JTransactionInput', TypeInfo(Interface2.JTransactionInput));
  TRegTypes.RegisterType('Interface2.JTransactionOutput', TypeInfo(Interface2.JTransactionOutput));
  TRegTypes.RegisterType('Interface2.JDateParser', TypeInfo(Interface2.JDateParser));
  TRegTypes.RegisterType('Interface2.JEnumType', TypeInfo(Interface2.JEnumType));
  TRegTypes.RegisterType('Interface2.JInputParser', TypeInfo(Interface2.JInputParser));
  TRegTypes.RegisterType('Interface2.JOutputParser', TypeInfo(Interface2.JOutputParser));
  TRegTypes.RegisterType('Interface2.Jparser_ParseException', TypeInfo(Interface2.Jparser_ParseException));
  TRegTypes.RegisterType('Interface2.JUriArrayFieldName', TypeInfo(Interface2.JUriArrayFieldName));
  TRegTypes.RegisterType('Interface2.Jparser_UriClass', TypeInfo(Interface2.Jparser_UriClass));
  TRegTypes.RegisterType('Interface2.JUriCustomizeFieldName', TypeInfo(Interface2.JUriCustomizeFieldName));
  TRegTypes.RegisterType('Interface2.JUriDateFieldName', TypeInfo(Interface2.JUriDateFieldName));
  TRegTypes.RegisterType('Interface2.JUriEnumFieldName', TypeInfo(Interface2.JUriEnumFieldName));
  TRegTypes.RegisterType('Interface2.JUriFileFieldName', TypeInfo(Interface2.JUriFileFieldName));
  TRegTypes.RegisterType('Interface2.JUriMethodName', TypeInfo(Interface2.JUriMethodName));
  TRegTypes.RegisterType('Interface2.JUriObjectFieldName', TypeInfo(Interface2.JUriObjectFieldName));
  TRegTypes.RegisterType('Interface2.JUriPrimitiveFieldName', TypeInfo(Interface2.JUriPrimitiveFieldName));
end;

initialization
  RegisterTypes;
end.

