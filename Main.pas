unit Main;

interface

uses Windows,Messages,SysUtils,Variants,Classes,Spin,
     Graphics,Controls,Forms,Dialogs,StdCtrls,ComCtrls,
     Menus,ExtCtrls,jpeg,MPlayer,ID3v1Library,ActiveX,
     MMDevApi,SpeechLib_TLB,OleServer;

const scPL = 0; {SortCtrl for listviews}
      scImg = 1;
      scRen = 2;
      scSS = 3;
      scSB = 4;
      scTR = 5;
      siArtist = 0; {TListView.SubItems[] constants}
      siAlbum = 1;
      siTrack = 2;
      siTitle = 3;
      siYear = 4;
      siGenre = 5;
      siComment = 6;
      siCaption = 0;{SlideShows}
      siDelay = 1;
      siSync = 2;
      siRepeat = 3;
      siOther = 4;
      siFont = 5;
      c_Font = 'Segue Print';
      Google = 'http://www.google.com/search?hl=en&source=hp&q=';
      c_HK = 41516;{os-unique ~ RegisterHotKey}
      vmNormal = 0;{ViewMode}
      vmMinimal = 1;
      vmFloating = 2;
      vmFullArt = 3;
      fsAudio = 1; {dlgOpen.Filter[s]}
      fsPlaylist = 2;
      fsBookmark = 3;
      fsSlideShow = 4;
      fsSoundBite = 5;
      fsText = 6;
      fsAny = 7;
      rvOk = 0;{modal dlg vals}
      rvCancel = 1;
      trStop = 0;{TextReader}
      trPlay = 1;
      trPause = 2;
      csMP = 0;{caption sets}
      csSS = 1;

type TSampleRec = record
       Sampling : boolean;
       PlaySecs : integer;
       slPix : TStringList;
     end;

     TUsurpRec = record
       Filename : string;
       Mode : TMPModes;
       Position : dword;
       CmdCap : string;
     end;

     TSlideShowRec = record
       Active : boolean;{should use Mode, but using TButton captions}
       Idx,Delay,Rep,Wait,RepCount : integer;
       Filename,ImgFile,Sync,Other : string;
       CoverArtWait : integer;
       usurped : TUSurpRec;
       SetOrig : boolean;
     end;

     TSoundBiteRec = record
       Delay,Wait : integer;
     end;

     TTextReaderRec = record
       Mode,Skips,ChrPos,Len,StreamNum : integer;
       StreamPos : OleVariant;
     end;

     TSortRec = record
       PLAsc,RenAsc,ImgAsc,SSAsc,SBAsc,TRAsc : boolean;
       SortCtrl,PLSortCol,RenSortCol,
       SSSortCol,SBSortCol,TRSortCol,
       ImgSortCol : integer;
     end;

     TfrmMain = class(TForm)
       mnu: TMainMenu;
       dlgOpen: TOpenDialog;
       mnuFile: TMenuItem;
       mnuOpen: TMenuItem;
       mnuBookmarks: TMenuItem;
       mnuGotobookmark: TMenuItem;
       mnuAddbookmark: TMenuItem;
       mnuExit: TMenuItem;
       N2: TMenuItem;
       mnuPlaylists: TMenuItem;
       mnuNewPL: TMenuItem;
       mnuPlayPL: TMenuItem;
       sb: TStatusBar;
       mnuAbout: TMenuItem;
       dlgSave: TSaveDialog;
       tmrTrack: TTimer;
       mnuSaveAs: TMenuItem;
       mnuSave: TMenuItem;
       mnuBookmarkVolume: TMenuItem;
       N1: TMenuItem;
       mnuTrack: TMenuItem;
       mnuPrevFile: TMenuItem;
       mnuPrevIdx: TMenuItem;
       mnuPlayPause: TMenuItem;
       mnuNextFile: TMenuItem;
       mnuNextIndex: TMenuItem;
       mnuStop: TMenuItem;
       mnuVolUp: TMenuItem;
       mnuVolDown: TMenuItem;
       N4: TMenuItem;
       mnuMixer: TMenuItem;
       mnuEditPL: TMenuItem;
       mnuAddPL: TMenuItem;
       mnuRemovePL: TMenuItem;
       mnuMoveUp: TMenuItem;
       mnuMoveDown: TMenuItem;
       mnuTags: TMenuItem;
       mnuShuffle: TMenuItem;
       mnuRepeat: TMenuItem;
       mnuShowTags: TMenuItem;
       mnuReloadTags: TMenuItem;
       mnuSaveTags: TMenuItem;
       mnuSavePlus: TMenuItem;
       mnuBuild: TMenuItem;
       mnuBuildFolders: TMenuItem;
       mnuJukebox: TMenuItem;
       mnuGetCoverArt: TMenuItem;
       mnuCoverArt: TMenuItem;
       mnuChangeArt: TMenuItem;
       mnuCopy: TMenuItem;
       pop: TPopupMenu;
       mnuPopFile: TMenuItem;
       mnuPopExit: TMenuItem;
       N6: TMenuItem;
       mnuPopChangeArt: TMenuItem;
       mnuPopJukebox: TMenuItem;
       mnuPopOpen: TMenuItem;
       mnuPopTrack: TMenuItem;
       mnuPopBookmarks: TMenuItem;
       mnuPopGotoBookmark: TMenuItem;
       N8: TMenuItem;
       mnuPopBookmarkwVolume: TMenuItem;
       mnuPopBookmark: TMenuItem;
       mnuPopPlaylists: TMenuItem;
       mnuPopBuild: TMenuItem;
       mnuPopPlaylistCoverArt: TMenuItem;
       mnuPopOnePlaylistPerFolder: TMenuItem;
       mnuPopRepeat: TMenuItem;
       mnuPopShuffle: TMenuItem;
       mnuPopSaveAs: TMenuItem;
       mnuPopSave: TMenuItem;
       mnuPopEdit: TMenuItem;
       mnuPopCopy: TMenuItem;
       mnuPopags: TMenuItem;
       mnuPopSavePlus: TMenuItem;
       mnuPopSaveTag: TMenuItem;
       mnuPopReload: TMenuItem;
       mnuPopTagDisplay: TMenuItem;
       mnuPopMoveDown: TMenuItem;
       mnuPopMoveUp: TMenuItem;
       mnuPopRemove: TMenuItem;
       mnuPopAdd: TMenuItem;
       mnuPopLoad: TMenuItem;
       mnuPopNew: TMenuItem;
       mnuHelp: TMenuItem;
       mnuDocumentation: TMenuItem;
       mnuGoogle: TMenuItem;
       mnuHomePage: TMenuItem;
       mnuReseqTrack: TMenuItem;
       mnuPopReseqTrack: TMenuItem;
       mnuFind: TMenuItem;
       mnuFindNext: TMenuItem;
       mnuPopFind: TMenuItem;
       mnuPopFindNext: TMenuItem;
       mnuPopPreviousFile: TMenuItem;
       mnuPopPreviousIndex: TMenuItem;
       mnuPopPlay: TMenuItem;
       mnuPopStop: TMenuItem;
       mnuPopNextIndex: TMenuItem;
       mnuPopNextFile: TMenuItem;
       N3: TMenuItem;
       mnuPopDecreaseVolume: TMenuItem;
       mnuPopIncreaseVolume: TMenuItem;
       mnuPopMixer: TMenuItem;
       mnuPopGoogle: TMenuItem;
       mnuPopCoverArt: TMenuItem;
       mnuNextPlaylist: TMenuItem;
       mnuPopNextPlaylist: TMenuItem;
       pnlLeft: TPanel;
       pnlTop: TPanel;
       pnlCmdPos: TPanel;
       tbPosition: TTrackBar;
       pnlCmd: TPanel;
       cmdPrevFile: TButton;
       cmdPrevIdx: TButton;
       cmdPlayPause: TButton;
       cmdNextIdx: TButton;
       cmdNextFile: TButton;
       cmdStop: TButton;
       tbVolume: TTrackBar;
       cmdJukebox: TButton;
       img: TImage;
       spl: TSplitter;
       mnuPreviousPlaylist: TMenuItem;
       mnuPopPreviousPlaylist: TMenuItem;
       mnuView: TMenuItem;
       mnuViewTags: TMenuItem;
       mnuViewCoverArt: TMenuItem;
       mnuViewPlaylistQueue: TMenuItem;
       N5: TMenuItem;
       mnuMenuBarPlaylist: TMenuItem;
       mnuViewFullArt: TMenuItem;
       N7: TMenuItem;
       mnuViewMinimal: TMenuItem;
       mnuViewNormal: TMenuItem;
       mnuPopView: TMenuItem;
       N9: TMenuItem;
       mnuPopViewFullScreenArt: TMenuItem;
       mnuPopViewMinimal: TMenuItem;
       mnuPopViewNormal: TMenuItem;
       N10: TMenuItem;
       mnuPopViewCoverArt: TMenuItem;
       mnuPopViewTags: TMenuItem;
       mnuPopViewPlaylistQueue: TMenuItem;
       mnuRename: TMenuItem;
       mnuPopRename: TMenuItem;
       mnuAddDurComment: TMenuItem;
       mnuPopAddDurComment: TMenuItem;
       mnuPasteToAll: TMenuItem;
       mnuPasteToAllArtist: TMenuItem;
       mnuPasteToAllAlbum: TMenuItem;
       mnuPasteToAllTitle: TMenuItem;
       mnuPasteToAllYear: TMenuItem;
       mnuPasteToAllGenre: TMenuItem;
       mnuPasteToAllComment: TMenuItem;
       mnuPopPasteToAll: TMenuItem;
       mnuPopPasteToAllComment: TMenuItem;
       mnuPopPasteToAllGenre: TMenuItem;
       mnuPopPasteToAllYear: TMenuItem;
       mnuPopPasteToAllTitle: TMenuItem;
       mnuPopPasteToAllAlbum: TMenuItem;
       mnuPopPasteToAllArtist: TMenuItem;
       mnuFindCurrent: TMenuItem;
       mnuPopFindCurrent: TMenuItem;
       mnuPopulateDurations: TMenuItem;
       mnuPopPopulateDurations: TMenuItem;
       mnuMakePortablePlaylists: TMenuItem;
       mnuPopMakePortablePlaylists: TMenuItem;
       mnuViewFloatingArt: TMenuItem;
       mnuPopViewFloatingArt: TMenuItem;
       mnuDynamicWallpaper: TMenuItem;
       mnuPopDynamicWallpaper: TMenuItem;
       pag: TPageControl;
       tabPlaylist: TTabSheet;
       tabTags: TTabSheet;
       tabImages: TTabSheet;
       lvImg: TListView;
       pnlQueue: TPanel;
       cmdMoveUp: TButton;
       cmdRemovePL: TButton;
       cmdMoveDown: TButton;
       cmdAddPL: TButton;
       cmdOpenPL: TButton;
       cmdCopy: TButton;
       cmdShuffle: TButton;
       cmdGoogle: TButton;
       chkRepeat: TCheckBox;
       cmdPrevPL: TButton;
       cmdNextPL: TButton;
       lvPL: TListView;
       pnlTags: TPanel;
       lblTagArtist: TLabel;
       lblTagAlbum: TLabel;
       lblTagTitle: TLabel;
       lblTagComment: TLabel;
       lblTagTrack: TLabel;
       lblTagYear: TLabel;
       lblTagGenre: TLabel;
       pnlTagCmd: TPanel;
       cmdReloadTags: TButton;
       cmdSaveTags: TButton;
       cmdSavePlus: TButton;
       cmdSaveAllTags: TButton;
       cmdRename: TButton;
       cmbGenre: TComboBox;
       edtArtist: TEdit;
       edtAlbum: TEdit;
       edtTitle: TEdit;
       edtComment: TEdit;
       edtYear: TEdit;
       edtTagFile: TEdit;
       spnTrack: TSpinEdit;
       pnlRename: TPanel;
       lvRen: TListView;
       pnlRenameCmd: TPanel;
       cmdRenameExec: TButton;
       cmdRenCancel: TButton;
       cmdRenRefresh: TButton;
       cmdRenBaseDir: TButton;
       cmbRenMask: TComboBox;
       pnlImgCmd: TPanel;
       cmdRenameImg: TButton;
       cmdCopyImg: TButton;
       cmdMoveImg: TButton;
       cmdDeleteImg: TButton;
       mnuSample: TMenuItem;
       mnuPopSample: TMenuItem;
       cmdDownload: TButton;
       mnuViewNormal2: TMenuItem;
       mnuPopViewNormal2: TMenuItem;
       tabSlideShow: TTabSheet;
       tabSoundBites: TTabSheet;
       tabTextReader: TTabSheet;
       edtImgDir: TEdit;
       lvSS: TListView;
       pnlSSCmd: TPanel;
       cmdNewSS: TButton;
       cmdOpenSS: TButton;
       cmdPlaySS: TButton;
       cmdRemoveSS: TButton;
       pnlSBCmd: TPanel;
       cmdNewSB: TButton;
       cmdDeleteSB: TButton;
       lvSB: TListView;
       pnlTRCmd: TPanel;
       cmdOpenTR: TButton;
       cmdPlayTR: TButton;
       cmdStopTR: TButton;
       cmdEditSS: TButton;
       mnuSlideShows: TMenuItem;
       mnuTextReader: TMenuItem;
       mnuPopTextReader: TMenuItem;
       mnuViewSlideShows: TMenuItem;
       mnuViewSoundBites: TMenuItem;
       mnuViewTextReader: TMenuItem;
       mnuPopViewSlideShows: TMenuItem;
       mnuPopViewSoundBites: TMenuItem;
       mnuPopViewTextReader: TMenuItem;
       cmdAddSlideShow: TButton;
       cmdMoveUpSS: TButton;
       cmdMoveDownSS: TButton;
       chkShuffleSS: TCheckBox;
       chkRepeatSS: TCheckBox;
       mnuNewSS: TMenuItem;
       mnuOpenSS: TMenuItem;
       mnuPlaySS: TMenuItem;
       mnuAddSS: TMenuItem;
       mnuEditSS: TMenuItem;
       mnuMoveUpSS: TMenuItem;
       mnuMoveDownSS: TMenuItem;
       mnuRemoveSS: TMenuItem;
       mnuShuffleSS: TMenuItem;
       mnuRepeatSS: TMenuItem;
       mnuVisitLibriVox: TMenuItem;
       mnuVisitGutenberg: TMenuItem;
       N11: TMenuItem;
       mnuCoverArtSlideshow: TMenuItem;
       mnuPopCoverArtSlideshow: TMenuItem;
       cmdLinkSS: TButton;
       mnuLinkSS: TMenuItem;
       tmrUsurp: TTimer;
       edtTRFile: TEdit;
       cmdQueueSB: TButton;
       cmdStopSS: TButton;
       cmdNewPL: TButton;
       cmdVoice: TButton;
       pnlCap: TPanel;
       mnuShowMenu: TMenuItem;
       mnuPopShowMenu: TMenuItem;
       spv: TSpVoice;
       mnuOpenTR: TMenuItem;
       mnuPlayTR: TMenuItem;
       mnuStopTR: TMenuItem;
       mnuVoiceTR: TMenuItem;
       mnuStopSS: TMenuItem;
       pnlSSCtrls: TPanel;
       cmdPrevSlide: TButton;
       cmdPrevSSIdx: TButton;
       cmdPlaySS2: TButton;
       cmdNextSSIdx: TButton;
       cmdNextSlide: TButton;
       cmdStopSS2: TButton;
       mnuNextSlide: TMenuItem;
       mnuPrevSlide: TMenuItem;
       mnuPopSlideshow: TMenuItem;
       mnuPopLinkPlaylist: TMenuItem;
       mnuPopRepeatSS: TMenuItem;
       mnuPopShuffleSS: TMenuItem;
       mnuPopMoveDownSS: TMenuItem;
       mnuPopMoveUpSS: TMenuItem;
       mnuPopRemoveSS: TMenuItem;
       mnuPopEditSS: TMenuItem;
       mnuPopNextSS: TMenuItem;
       mnuPopPrevSS: TMenuItem;
       mnuPopStopSS: TMenuItem;
       mnuPopPlaySS: TMenuItem;
       mnuPopAddSS: TMenuItem;
       mnuPopOpenSS: TMenuItem;
       mnuPopNewSS: TMenuItem;
       cmdPasteTR: TButton;
       mnuPasteTR: TMenuItem;
       cmdEditSB: TButton;
       cmdPrevFileTR: TButton;
       cmdPrevIdxTR: TButton;
       cmdNextIdxTR: TButton;
       cmdNextFileTR: TButton;
       cmdRenameSS: TButton;
       mnuRenameSS: TMenuItem;
       mnuPopRenameSS: TMenuItem;
       redTR: TRichEdit;
       cmdFontTR: TButton;
       mnuMenubars: TMenuItem;
       mnuMenuBarTags: TMenuItem;
       mnuMenuBarCoverArt: TMenuItem;
       mnuMenuBarSlideshow: TMenuItem;
       mnuMenuBarSoundbites: TMenuItem;
       mnuMenuBarTextReader: TMenuItem;
       mnuPopMenuBarMenubars: TMenuItem;
       mnuPopMenuBarTextReader: TMenuItem;
       mnuPopMenuBarSoundbites: TMenuItem;
       mnuPopMenuBarSlideshow: TMenuItem;
       mnuPopMenuBarCoverArt: TMenuItem;
       mnuPopMenuBarTags: TMenuItem;
       mnuPopMenuBarPlaylist: TMenuItem;
       mnuImageViewer: TMenuItem;
       mnuImageCollector: TMenuItem;
       mnuPopImageViewer: TMenuItem;
       mnuPopImageCollector: TMenuItem;
       mnuPublish: TMenuItem;
       mnuPopPublish: TMenuItem;
       mnuReport: TMenuItem;
       mnuPopReport: TMenuItem;
       mnuTRFont: TMenuItem;
       mnuTRSkipAhead: TMenuItem;
       mnuTRSkipBack: TMenuItem;
       mnuTRNextFile: TMenuItem;
       mnuTRPrevFile: TMenuItem;
       dlgFont: TFontDialog;
    mnuPopOpenTR: TMenuItem;
    mnuPopPlayTR: TMenuItem;
    mnuPopNextIdxTR: TMenuItem;
    mnuPopPrevIdxTR: TMenuItem;
    mnuPopStopTR: TMenuItem;
    mnuPopNextFileTR: TMenuItem;
    mnuPopPrevFileTR: TMenuItem;
    mnuPopPasteTR: TMenuItem;
    mnuPopFontTR: TMenuItem;
    mnuPopVoice: TMenuItem;
    cmdCopyTR: TButton;
    mnuCopyTR: TMenuItem;
    mnuPopCopyTR: TMenuItem;
       procedure mnuExitClick(Sender: TObject);
       procedure mnuAboutClick(Sender: TObject);
       procedure FormActivate(Sender: TObject);
       procedure FormCreate(Sender: TObject);
       procedure FormClose(Sender: TObject; var Action: TCloseAction);
       procedure mnuOpenClick(Sender: TObject);
       procedure mnuAddbookmarkClick(Sender: TObject);
       procedure mnuGotobookmarkClick(Sender: TObject);
       procedure mnuNewPLClick(Sender: TObject);
       procedure mnuPlayPLClick(Sender: TObject);
       procedure tmrTrackTimer(Sender: TObject);
       procedure cmdPrevFileClick(Sender: TObject);
       procedure cmdPrevIdxClick(Sender: TObject);
       procedure cmdNextIdxClick(Sender: TObject);
       procedure cmdNextFileClick(Sender: TObject);
       procedure tbPositionChange(Sender: TObject);
       procedure cmdAddPLClick(Sender: TObject);
       procedure cmdRemovePLClick(Sender: TObject);
       procedure cmdMoveUpClick(Sender: TObject);
       procedure cmdMoveDownClick(Sender: TObject);
       procedure mnuSaveAsClick(Sender: TObject);
       procedure mnuSaveClick(Sender: TObject);
       procedure lvPLDblClick(Sender: TObject);
       procedure cmdReloadTagsClick(Sender: TObject);
       procedure cmdSaveTagsClick(Sender: TObject);
       procedure cmdShuffleClick(Sender: TObject);
       procedure lvPLColumnClick(Sender: TObject; Column: TListColumn);
       procedure cmdSavePlusClick(Sender: TObject);
       procedure cmdStopClick(Sender: TObject);
       procedure tbVolumeChange(Sender: TObject);
       procedure mnuBookmarkVolumeClick(Sender: TObject);
       procedure mnuVolUpClick(Sender: TObject);
       procedure mnuVolDownClick(Sender: TObject);
       procedure chkRepeatClick(Sender: TObject);
       procedure mnuRepeatClick(Sender: TObject);
       procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
       procedure mnuBuildFoldersClick(Sender: TObject);
       procedure edtTitleChange(Sender: TObject);
       procedure FormResize(Sender: TObject);
       procedure cmdJukeboxClick(Sender: TObject);
       procedure mnuGetCoverArtClick(Sender: TObject);
       procedure mnuCoverArtClick(Sender: TObject);
       procedure mnuChangeArtClick(Sender: TObject);
       procedure imgClick(Sender: TObject);
       procedure cmdCopyClick(Sender: TObject);
       procedure mnuPopRepeatClick(Sender: TObject);
       procedure mnuDocumentationClick(Sender: TObject);
       procedure cmdRenameImgClick(Sender: TObject);
       procedure cmdCopyImgClick(Sender: TObject);
       procedure cmdMoveImgClick(Sender: TObject);
       procedure cmdDeleteImgClick(Sender: TObject);
       procedure lvImgSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
       procedure lvImgColumnClick(Sender: TObject; Column: TListColumn);
       procedure cmdGoogleClick(Sender: TObject);
       procedure mnuVisitLibriVoxClick(Sender: TObject);
       procedure mnuHomePageClick(Sender: TObject);
       procedure mnuReseqTrackClick(Sender: TObject);
       procedure mnuFindClick(Sender: TObject);
       procedure mnuFindNextClick(Sender: TObject);
       procedure mnuNextPlaylistClick(Sender: TObject);
       procedure mnuMixerClick(Sender: TObject);
       procedure mnuPreviousPlaylistClick(Sender: TObject);
       procedure cmdSaveAllTagsClick(Sender: TObject);
       procedure mnuViewPlaylistQueueClick(Sender: TObject);
       procedure mnuMenuBarPlaylistClick(Sender: TObject);
       procedure mnuViewFullArtClick(Sender: TObject);
       procedure mnuViewMinimalClick(Sender: TObject);
       procedure mnuViewNormalClick(Sender: TObject);
       procedure cmdRenameClick(Sender: TObject);
       procedure cmdRenameExecClick(Sender: TObject);
       procedure cmdRenCancelClick(Sender: TObject);
       procedure lvRenDblClick(Sender: TObject);
       procedure cmdRenRefreshClick(Sender: TObject);
       procedure cmbRenMaskSelect(Sender: TObject);
       procedure cmdRenBaseDirClick(Sender: TObject);
       procedure mnuAddDurCommentClick(Sender: TObject);
       procedure mnuPasteToAllArtistClick(Sender: TObject);
       procedure mnuPasteToAllAlbumClick(Sender: TObject);
       procedure mnuPasteToAllTitleClick(Sender: TObject);
       procedure mnuPasteToAllYearClick(Sender: TObject);
       procedure mnuPasteToAllGenreClick(Sender: TObject);
       procedure mnuPasteToAllCommentClick(Sender: TObject);
       procedure mnuFindCurrentClick(Sender: TObject);
       procedure WMHotKey(var Message: TMessage); message WM_HOTKEY;
       procedure mnuPopulateDurationsClick(Sender: TObject);
       procedure mnuMakePortablePlaylistsClick(Sender: TObject);
       procedure mnuViewFloatingArtClick(Sender: TObject);
       procedure mnuDynamicWallpaperClick(Sender: TObject);
       procedure pagChange(Sender: TObject);
       procedure mnuViewTagsClick(Sender: TObject);
       procedure mnuViewCoverArtClick(Sender: TObject);
       procedure mnuSampleClick(Sender: TObject);
       procedure mnuViewNormal2Click(Sender: TObject);
       procedure mnuViewSlideShowsClick(Sender: TObject);
       procedure mnuViewSoundBitesClick(Sender: TObject);
       procedure mnuViewTextReaderClick(Sender: TObject);
       procedure cmdNewSSClick(Sender: TObject);
       procedure cmdOpenSSClick(Sender: TObject);
       procedure cmdRemoveSSClick(Sender: TObject);
       procedure cmdAddSlideShowClick(Sender: TObject);
       procedure cmdEditSSClick(Sender: TObject);
       procedure cmdMoveUpSSClick(Sender: TObject);
       procedure cmdMoveDownSSClick(Sender: TObject);
       procedure mnuShuffleSSClick(Sender: TObject);
       procedure mnuRepeatSSClick(Sender: TObject);
       procedure mnuVisitGutenbergClick(Sender: TObject);
       procedure mnuCoverArtSlideshowClick(Sender: TObject);
       procedure cmdLinkSSClick(Sender: TObject);
       procedure cmdNewSBClick(Sender: TObject);
       procedure cmdDeleteSBClick(Sender: TObject);
       procedure tmrUsurpTimer(Sender: TObject);
       procedure edtImgDirDblClick(Sender: TObject);
       procedure edtTagFileDblClick(Sender: TObject);
       procedure lvRenColumnClick(Sender: TObject; Column: TListColumn);
       procedure lvSSColumnClick(Sender: TObject; Column: TListColumn);
       procedure lvSBColumnClick(Sender: TObject; Column: TListColumn);
       procedure lvTRColumnClick(Sender: TObject; Column: TListColumn);
       procedure cmdQueueSBClick(Sender: TObject);
       procedure cmdStopSSClick(Sender: TObject);
       procedure lvSSSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
       procedure mnuShowMenuClick(Sender: TObject);
       procedure lvSSDblClick(Sender: TObject);
       procedure cmdOpenTRClick(Sender: TObject);
       procedure cmdVoiceClick(Sender: TObject);
       procedure cmdStopTRClick(Sender: TObject);
       procedure cmdPlayTRClick(Sender: TObject);
       procedure spvSentence(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant; CharacterPosition, Length: Integer);
       procedure cmdPrevSlideClick(Sender: TObject);
       procedure cmdPrevSSIdxClick(Sender: TObject);
       procedure cmdNextSSIdxClick(Sender: TObject);
       procedure cmdNextSlideClick(Sender: TObject);
       procedure cmdPasteTRClick(Sender: TObject);
       procedure cmdEditSBClick(Sender: TObject);
       procedure cmdPlaySSClick(Sender: TObject);
       procedure cmdPlayPauseClick(Sender: TObject);
       procedure spvEndStream(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant);
       procedure cmdPrevIdxTRClick(Sender: TObject);
       procedure cmdNextIdxTRClick(Sender: TObject);
       procedure pnlCapClick(Sender: TObject);
       procedure mnuMenuBarTagsClick(Sender: TObject);
       procedure mnuMenuBarCoverArtClick(Sender: TObject);
       procedure mnuMenuBarSlideshowClick(Sender: TObject);
       procedure mnuMenuBarSoundbitesClick(Sender: TObject);
       procedure mnuMenuBarTextReaderClick(Sender: TObject);
       procedure mnuImageViewerClick(Sender: TObject);
       procedure mnuImageCollectorClick(Sender: TObject);
       procedure mnuPublishClick(Sender: TObject);
       procedure mnuReportClick(Sender: TObject);
       procedure cmdPrevFileTRClick(Sender: TObject);
       procedure cmdNextFileTRClick(Sender: TObject);
       procedure cmdFontTRClick(Sender: TObject);
       procedure cmdCopyTRClick(Sender: TObject);
     private
       bInit,bBuild,bBuildArt,bSetting : boolean;
       UDir,PLFile,ImgFile,sFind,LastImage : string;
       ump : TUsurpRec;
       PLIdx,ViewMode : integer;
       ss : TSlideShowRec;
       tr : TTextReaderRec;
       sbite : TSoundBiteRec;
       SampleRec : TSampleRec;
       procedure DropMsg(var msg : TWMDropFiles); message WM_DROPFILES;
       procedure DoFile(sFile : string);
       procedure LoadOptions;
       procedure CreateBookmark(AskName : string; AddVol : boolean);
       procedure LoadBookmark(sFile : string);
       procedure SetPic(sFile : string);
       procedure DelPic;
       procedure SetPlayCap(CapSet : byte; bPlay : boolean);
       procedure SetCurrentFile;
       procedure LoadEditTags;
       procedure UpdateTags(sFile : string);
       procedure AddTrack(lv : TListView; sFile : string);
       procedure NextTrack;
       procedure PrevTrack;
       function GetTrackIdx(sFile : string) : integer;
       procedure LoadPlaylist(sFile : string);
       procedure SavePlaylist;
       procedure StartPlaylist;
       procedure FixPlaylist(sFile : string);
       procedure GetArt(Dir,Title : string);
       procedure AskToBuild;
       procedure AutoBookmark;
       procedure PlayFile(sFile : string; StartPos : dword);
       function GetFolderMedia(sDir : string) : boolean;
       procedure ExchangeItems(lv : TListView; const n2 : integer);
       procedure SetVolume(Vol : single);
       procedure SetVis;
       procedure FindMatches(Idx : integer);
       function TagBasedFilename(i : TListItem) : string;
       procedure PasteToAll(Fld : byte);
       procedure SetFloat;
       procedure Sample;
       procedure StopSample;
       procedure LoadSS(sFile : string; StartPos : integer);
       procedure StartSS(Slide : integer);
       procedure LoadTR(sFile : string; ViewPos : integer);
       procedure StartTR(nSkips : integer);
       procedure NextSS;
       procedure SaveSS(sl : TStrings; sFile : string);
       procedure ShuffleLV(lv : TListView);
       procedure AddSB(sFile,Audio,Start,Dur : string);
       procedure SaveSB(Audio,Start,Dur : string);
       procedure ListSoundBites;
       procedure PlaySB(sFile : string);
       procedure DelFileFromDisk;
     public
       mp : TMediaPlayer;
       procedure Usurp(Start : boolean);
       function AudioLen(sFile : string) : dword;
       procedure AppMessage(var Msg : TMsg; var bHandled : boolean);
     end;

var frmMain : TfrmMain;
    sr : TSortRec;
    Tags : TID3v1Tag = nil;
    TmpFile : string;
    endpointVolume : IAudioEndpointVolume = nil;

implementation

{$R *.dfm}

uses VPAExt,EditSS,EditSB,Splash,Voice,
     ShellAPI,ClipBrd;

procedure TfrmMain.FormCreate(Sender: TObject);

var deviceEnumerator : IMMDeviceEnumerator;
    defaultDevice : IMMDevice;

begin
  ss.Idx := -1;
  PLIdx := -1;
  ViewMode := vmNormal;
  SampleRec.slPix := TStringList.Create;
  ss.SetOrig := true;
  tr.Mode := trStop;
  TmpFile := HDir + 'FAR.tmp';
  img.Picture.Graphic := nil;{unload dev img}
  Application.OnMessage := AppMessage;
  Tags := TID3v1Tag.Create;
  DragAcceptFiles(Handle,true);
  mp := TMediaPlayer.Create(Self);
  mp.Parent := Self;
  mp.Visible := false;

  if InParams('/approot') then
    UDir := NoFinalBS(HDir)
  else
    UDir := GetDataPath + 'FAR';

  if not DirectoryExists(UDir) then MkDir(UDir);
  UDir := UDir + '\';
  if not DirectoryExists(UDir + 'Bookmarks') then MkDir(UDir + 'Bookmarks');
  if not DirectoryExists(UDir + 'Playlists') then MkDir(UDir + 'Playlists');
  if not DirectoryExists(UDir + 'Playlists\Audiobooks') then MkDir(UDir + 'Playlists\Audiobooks');
  if not DirectoryExists(UDir + 'SlideShows') then MkDir(UDir + 'SlideShows');
  if not DirectoryExists(UDir + 'SoundBites') then MkDir(UDir + 'SoundBites');
  pag.ActivePageIndex := 0;
  sb.Panels[0].Text := 'Ready';
  CoCreateInstance(CLASS_IMMDeviceEnumerator,nil,CLSCTX_INPROC_SERVER,IID_IMMDeviceEnumerator,deviceEnumerator);
  deviceEnumerator.GetDefaultAudioEndpoint(eRender,eConsole,defaultDevice);
  defaultDevice.Activate(IID_IAudioEndpointVolume,CLSCTX_INPROC_SERVER,nil,endpointVolume);
end;

procedure TfrmMain.FormActivate(Sender: TObject);

var v : single;

begin
  if bInit then exit;

  try
    sb.Height := sb.Canvas.TextHeight('Q') + 2;
    sb.Panels[0].Width := sb.Canvas.TextWidth(' Stopped ');
    sb.Panels[1].Width := sb.Canvas.TextWidth('99:99:99');
    cmdPlayPause.SetFocus;

    if endpointVolume <> nil then
    begin
      endpointVolume.GetMasterVolumeLevelScaler(v);
      tbVolume.Position := Round(v * 100);
      if tbVolume.Position < 10 then tbVolume.Position := 10;
    end;
  except
  end;

  LoadWinPos(Self,UDir + 'FAR.ini');
  LoadOptions;
  ListSoundBites;
  bInit := true;
  tmrTrack.Enabled := true;{que}

  if frmSplash <> nil then
  begin
    frmSplash.Hide;
    frmSplash.Free;
  end;

  if (not InParams('_Start.fbm')) and
   (not FilesExist(UDir + 'Playlists\*.m3u')) then
    AskToBuild;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    tmrTrack.Enabled := false;
    SampleRec.slPix.Free;
    UnregisterHotKey(Handle,c_HK);
    AutoBookmark;
    SaveWinPos(Self,UDir + 'FAR.ini');
    AddAppVar('FAR','LeftWidth',IntToStr(pnlLeft.Width));
    AddAppVar('FAR','MenubarPlaylist',YN(pnlQueue.Visible));
    AddAppVar('FAR','MenubarTags',YN(pnlTagCmd.Visible));
    AddAppVar('FAR','MenubarCoverArt',YN(pnlImgCmd.Visible));
    AddAppVar('FAR','MenubarSlideshow',YN(pnlSSCmd.Visible));
    AddAppVar('FAR','MenubarSoundbites',YN(pnlSBCmd.Visible));
    AddAppVar('FAR','MenubarTextReader',YN(pnlTRCmd.Visible));
    AddAppVar('FAR','ShowMenu',YN(mnuShowMenu.Checked));
    AddAppVar('FAR','AddDurComment',YN(mnuAddDurComment.Checked));
    AddAppVar('FAR','ViewMode',IntToStr(ViewMode));
    AddAppVar('FAR','LastImage',LastImage);
    AddAppVar('FAR','DynamicWallpaper',YN(mnuDynamicWallpaper.Checked));
    AddAppVar('FAR','CoverArtSlideshow',YN(mnuCoverArtSlideshow.Checked));
    AddAppVar('FAR','TRFile',edtTRFile.Text);
    AddAppVar('FAR','TRRate',IntToStr(spv.Rate));
    AddAppVar('FAR','TRVolume',IntToStr(spv.Volume));
    AddAppVar('FAR','TRVoice',frmVoice.cmbVoice.Text);
    AddAppVar('FAR','TRFontName',redTR.Font.Name);
    AddAppVar('FAR','TRFontSize',IntToStr(redTR.Font.Size));
    AddAppVar('FAR','TRFontColor',IntToStr(redTR.Font.Color));
    AddAppVar('FAR','TRFontBold',YN(fsBold in redTR.Font.Style));
    AddAppVar('FAR','TRFontItalic',YN((fsItalic in redTR.Font.Style)));
    mp.Free;
    if Tags <> nil then FreeAndNil(Tags);
  except
  end;
end;

procedure TfrmMain.AppMessage(var Msg : TMsg; var bHandled : boolean);
begin
  bHandled := ((mp.Mode = mpPlaying) or
   (cmdPlaySS.Caption = 'Pause')) and
   ((WM_SYSCOMMAND = Msg.Message) and
   (SC_SCREENSAVE = Msg.wParam));
end;

procedure TfrmMain.LoadOptions;

var n,vk : integer;
    s : string;

begin
  try
    for n := 0 to 147 do
      cmbGenre.Items.Add(ID3Genres[n]);

    LastImage := GetAppVar('FAR','LastImage');
    s := GetAppVar('FAR','AddDurComment');
    if s <> '' then mnuAddDurComment.Checked := YN(s);
    mnuPopAddDurComment.Checked := mnuAddDurComment.Checked;
    s := GetAppVar('FAR','DynamicWallpaper');
    if s <> '' then mnuDynamicWallpaper.Checked := YN(s);
    mnuPopDynamicWallpaper.Checked := mnuDynamicWallpaper.Checked;
    s := GetAppVar('FAR','CoverArtSlideshow');
    if s <> '' then mnuCoverArtSlideshow.Checked := YN(s);
    mnuPopCoverArtSlideshow.Checked := mnuCoverArtSlideshow.Checked;
    s := GetAppVar('FAR','MenubarPlaylist');
    if s <> '' then pnlQueue.Visible := YN(s);
    mnuMenubarPlaylist.Checked := pnlQueue.Visible;
    mnuPopMenubarPlaylist.Checked := pnlQueue.Visible;
    s := GetAppVar('FAR','MenubarTags');
    if s <> '' then pnlTagCmd.Visible := YN(s);
    mnuMenubarTags.Checked := pnlTagCmd.Visible;
    mnuPopMenubarTags.Checked := pnlTagCmd.Visible;
    s := GetAppVar('FAR','MenubarCoverArt');
    if s <> '' then pnlImgCmd.Visible := YN(s);
    mnuMenubarCoverArt.Checked := pnlImgCmd.Visible;
    mnuPopMenubarCoverArt.Checked := pnlImgCmd.Visible;
    s := GetAppVar('FAR','MenubarSlideshow');
    if s <> '' then pnlSSCmd.Visible := YN(s);
    mnuMenubarSlideshow.Checked := pnlSSCmd.Visible;
    mnuPopMenubarSlideshow.Checked := pnlSSCmd.Visible;
    s := GetAppVar('FAR','MenubarSoundbites');
    if s <> '' then pnlSBCmd.Visible := YN(s);
    mnuMenubarSoundbites.Checked := pnlSBCmd.Visible;
    mnuPopMenubarSoundbites.Checked := pnlSBCmd.Visible;
    s := GetAppVar('FAR','MenubarTextReader');
    if s <> '' then pnlTRCmd.Visible := YN(s);
    mnuMenubarTextReader.Checked := pnlTRCmd.Visible;
    mnuPopMenubarTextReader.Checked := pnlTRCmd.Visible;
    s := GetAppVar('FAR','LeftWidth');
    if s <> '' then pnlLeft.Width := StrToInt2(s);
    s := GetAppVar('FAR','ShowMenu');
    if (s <> '') and (not YN(s)) then Menu := nil;
    mnuShowMenu.Checked := Menu <> nil;
    mnuPopShowMenu.Checked := Menu <> nil;
    frmVoice.edtRate.Value := StrToInt2(GetAppVar('FAR','TRRate'));
    frmVoice.edtVolume.Value := StrToInt2(GetAppVar('FAR','TRVolume'));
    edtTRFile.Text := GetAppVar('FAR','TRFile');
    if FileExists(edtTRFile.Text) then redTR.Lines.LoadFromFile(edtTRFile.Text);
    s := GetAppVar('FAR','TRFontName');
    if s <> '' then redTR.Font.Name := s;
    s := GetAppVar('FAR','TRFontSize');
    if s <> '' then redTR.Font.Size := StrToInt2(s);
    s := GetAppVar('FAR','TRFontColor');
    if s <> '' then redTR.Font.Color := StrToInt2(s);
    s := GetAppVar('FAR','TRFontBold');
    if (s <> '') and (YN(s)) then redTR.Font.Style := redTR.Font.Style + [fsBold];
    s := GetAppVar('FAR','TRFontItalic');
    if (s <> '') and (YN(s)) then redTR.Font.Style := redTR.Font.Style + [fsItalic];

    frmVoice.cmbVoice.ItemIndex := frmVoice.cmbVoice.
     Items.IndexOf(GetAppVar('FAR','TRVoice'));

    vk := -1;

    for n := 1 to ParamCount do
    begin
      if lowercase(copy(ParamStr(n),1,3)) = ('/hk') then
      begin
        vk := StrToInt2(copy(ParamStr(n),4,2));
        break;
      end;
    end;

    case vk of
      1  : vk := VK_F1;
      2  : vk := VK_F2;
      3  : vk := VK_F3;
      4  : vk := VK_F4;
      5  : vk := VK_F5;
      6  : vk := VK_F6;
      7  : vk := VK_F7;
      8  : vk := VK_F8;
      9  : vk := VK_F9;
      10 : vk := VK_F10;
      11 : vk := VK_F11;
      else vk := VK_F12;
    end;

    RegisterHotKey(Handle,c_HK,MOD_CONTROL,vk);
    SetVis;{.Enabled:=false}
    s := GetAppVar('FAR','ViewMode');

    if StrToInt2(s) = vmMinimal then
    begin
      mnu := nil;
      ViewMode := vmMinimal;
    end
    else if StrToInt2(s) = vmFloating then
      mnuViewFloatingArtClick(Self)
    else if StrToInt2(s) = vmFullArt then
      mnuViewFullArtClick(Self);

    if FileExists(LastImage) then
      SetPic(LastImage);

    for n := 1 to ParamCount do
      if FileExists(ParamStr(n)) then
        DoFile(ParamStr(n))
      else if DirectoryExists(ParamStr(n)) then
        DoFile(ParamStr(n));
  except
  end;
end;

procedure TfrmMain.AutoBookmark;
begin
  if mp.Mode in [mpPlaying,mpPaused] then
    CreateBookmark('Autosave.fbm',true);
end;

procedure TfrmMain.WMHotKey(var Message : TMessage);
begin
  WindowState := wsNormal;
  Show;
  Application.BringToFront;
end;

procedure TfrmMain.SetVis;
begin
  if mnuShowMenu.Checked then
    Menu := mnu
  else
    Menu := nil;

  mnuReloadTags.Enabled := false;
  mnuRename.Enabled := false;
  mnuSaveTags.Enabled := false;
  mnuSavePlus.Enabled := false;
  mnuPopReload.Enabled := false;
  mnuPopSaveTag.Enabled := false;
  mnuPopSavePlus.Enabled := false;
  mnuPopRename.Enabled := false;
  cmdRemovePL.Enabled := false;
  cmdMoveUp.Enabled := false;
  cmdMoveDown.Enabled := false;
  mnuRemovePL.Enabled := false;
  mnuMoveUp.Enabled := false;
  mnuMoveDown.Enabled := false;
  mnuPopRemove.Enabled := false;
  mnuPopMoveUp.Enabled := false;
  mnuPopMoveDown.Enabled := false;

  if pag.ActivePage = tabImages then
  begin
    sr.SortCtrl := scImg;
  end
  else if pag.ActivePage = tabSlideshow then
  begin
    sr.SortCtrl := scSS;
    lvSS.SetFocus;
  end
  else if pag.ActivePage = tabSoundbites then
  begin
    sr.SortCtrl := scSB;
    lvSB.SetFocus;
  end
  else if pag.ActivePage = tabTextReader then
  begin
    sr.SortCtrl := scTR;
    redTR.SetFocus;
  end
  else if pag.ActivePage = tabTags then
  begin
    sr.SortCtrl := scRen;
    mnuReloadTags.Enabled := true;
    mnuRename.Enabled := true;
    mnuSaveTags.Enabled := true;
    mnuSavePlus.Enabled := true;
    mnuPopReload.Enabled := true;
    mnuPopSaveTag.Enabled := true;
    mnuPopSavePlus.Enabled := true;
    mnuPopRename.Enabled := true;

    if lvPL.Selected <> nil then
      edtTagFile.Text := lvPL.Selected.Caption;

    LoadEditTags;
    edtArtist.SetFocus;
  end
  else if pag.ActivePage = tabPlaylist then
  begin
    sr.SortCtrl := scPL;
    mnuRemovePL.Enabled := true;
    mnuMoveUp.Enabled := true;
    mnuMoveDown.Enabled := true;
    mnuPopRemove.Enabled := true;
    mnuPopMoveUp.Enabled := true;
    mnuPopMoveDown.Enabled := true;
    cmdRemovePL.Enabled := true;
    cmdMoveUp.Enabled := true;
    cmdMoveDown.Enabled := true;
    lvPL.SetFocus;
  end;

  tmrTrack.Enabled := (bInit) and
   (pag.ActivePage <> tabTags) and
   ((mp.Filename <> '') or (ss.Active));
end;

procedure TfrmMain.imgClick(Sender: TObject);
begin
  if ViewMode = vmFloating then
  begin
    mnuViewFloatingArtClick(Self);
    exit;
  end
  else if ViewMode = vmFullArt then
  begin
    mnuViewFullArtClick(Self);
    exit;
  end;

  SetPic('');
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_Space) and
   (Shift <> [ssAlt]) and
   (pag.ActivePage = tabPlaylist)
    then
  begin
    Key := 0;
    cmdPlayPauseClick(Self);
  end;

  if (Key = VK_Space) and
   (Shift <> [ssAlt]) and
   (pag.ActivePage = tabSlideshow) then
  begin
    Key := 0;
    cmdPlaySSClick(Self);
  end;

  if (Key = VK_Space) and
   (Shift <> [ssAlt]) and
   (pag.ActivePage = tabTextReader) then
  begin
    Key := 0;
    cmdPlayTRClick(Self);
  end;

  if (Shift = [ssAlt]) and (Key = VK_Prior) then
  begin
    if tbVolume.Position > 90 then
      tbVolume.Position := 100
    else
      tbVolume.Position := tbVolume.Position + 10;
  end;

  if (Shift = [ssAlt]) and (Key = VK_Next) then
  begin
    if tbVolume.Position < 10 then
      tbVolume.Position := 0
    else
      tbVolume.Position := tbVolume.Position - 10;
  end;

  if (Shift = [ssCtrl]) and
   (Key = 65) and
   (ActiveControl = lvPL) then
  begin
    lvPL.SelectAll;
    Key := 0;
  end;

  if (Shift = [ssCtrl]) and
   (Key = 65) and
   (ActiveControl = lvSS) then
  begin
    lvSS.SelectAll;
    Key := 0;
  end;

  if (Shift = [ssCtrl]) and
   (Key = 65) and
   (ActiveControl = lvSB) then
  begin
    lvSB.SelectAll;
    Key := 0;
  end;


  if (Shift = [ssAlt]) and (Key = VK_Delete) then
    DelFileFromDisk;

  if (Shift = [ssAlt]) and (Key = VK_Left) then
    cmdPrevIdxClick(Self);

  if (Shift = [ssAlt]) and (Key = VK_Right) then
    cmdNextIdxClick(Self);

  if (Shift = [ssAlt]) and (Key = VK_Up) then
    cmdPrevFileClick(Self);

  if (Shift = [ssAlt]) and (Key = VK_Down) then
    cmdNextFileClick(Self);

  if (Shift = [ssAlt]) and (Key = VK_Return) then
    mnuViewFullArtClick(Self);

  if ((ActiveControl = edtArtist) or
   (ActiveControl = edtAlbum) or
   (ActiveControl = spnTrack) or
   (ActiveControl = edtTitle) or
   (ActiveControl = edtYear) or
   (ActiveControl = edtComment) or
   (ActiveControl = cmbGenre)) and
   (Key = VK_Return) then
   begin
     Key := 0;
     cmdSaveTagsClick(Self);
   end;

  if (ActiveControl = lvPL) and
   (Key = VK_Return) then
     lvPLDblClick(Self);

  if (ActiveControl = lvSS) and
   (Key = VK_Return) then
     lvSSDblClick(Self);

  if (Key = VK_Escape) and (pnlRename.Visible) then
  begin
    Key := 0;
    cmdRenCancelClick(Self);
  end;

  if (Key = VK_Escape) and (pag.ActivePage = tabTags) then
  begin
    Key := 0;
    mnuViewPlaylistQueueClick(Self);
  end;

  if (Key = VK_Escape) and (BorderStyle = bsNone) then
    mnuViewNormalClick(Self);

  if (Key = VK_Delete) and (pag.ActivePage = tabImages) then
    DelPic;

  if (Key = VK_Delete) and (ActiveControl = lvPL) then
    cmdRemovePLClick(Self);

  if (Key = VK_Insert) and (ActiveControl = lvPL) then
    cmdAddPLClick(Self);

  if (Key = VK_Delete) and (ActiveControl = lvSS) then
    cmdRemoveSSClick(Self);

  if (Key = VK_Insert) and (ActiveControl = lvSS) then
    cmdAddSlideShowClick(Self);
end;

function SortByColumn(Item1,Item2 : TListItem; Data: integer) : integer; stdcall;
begin
  if Data = 0 then
    Result := AnsiCompareText(Item1.Caption,Item2.Caption)
  else
    Result := AnsiCompareText(Item1.SubItems[Data - 1],
     Item2.SubItems[Data - 1]);

  if sr.SortCtrl = scPL then
  begin
    if not sr.PLAsc then Result := -Result;
  end
  else if sr.SortCtrl = scImg then
  begin
    if not sr.ImgAsc then Result := -Result;
  end
  else if sr.SortCtrl = scRen then
  begin
    if not sr.RenAsc then Result := -Result;
  end
  else if sr.SortCtrl = scSS then
  begin
    if not sr.SSAsc then Result := -Result;
  end
  else if sr.SortCtrl = scSB then
  begin
    if not sr.SBAsc then Result := -Result;
  end
  else if sr.SortCtrl = scTR then
  begin
    if not sr.TRAsc then Result := -Result;
  end;
end;

procedure TfrmMain.DropMsg(var msg : TWMDropFiles);

var n,nFile : integer;
    Files : array[0..255] of char;

begin
  nFile := DragQueryFile(Msg.Drop,$FFFFFFFF,Files,0);

  try
    for n := 0 to nFile - 1 do
      DoFile(copy(Files,0,DragQueryFile(Msg.Drop,n,Files,255)));
  except
  end;

  Msg.Result := 0;
  DragFinish(msg.Drop);
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if pnlLeft.Width < 2 then pnlLeft.Width := 2;
end;

procedure TfrmMain.edtTagFileDblClick(Sender: TObject);
begin
  WinExec(ExtractFilePath(edtTagFile.Text),'');
end;

procedure TfrmMain.edtTitleChange(Sender: TObject);
begin
  if InStrSet(lowercase(copy(edtTitle.Text,Length(
   edtTitle.Text) - 3,4)),'.mp3,.wma,.wav,.mid,.fsb') then
    edtTitle.Text := copy(edtTitle.Text,1,Length(edtTitle.Text) - 4);
end;

procedure TfrmMain.AddTrack(lv : TListView; sFile : string);

var i : TListItem;

begin
  Application.ProcessMessages;
  if not FileExists(sFile) then exit;
  if GetTrackIdx(sFile) <> -1 then exit;
  Tags.LoadFromFile(sFile);
  i := lvPL.Items.Add;
  i.Caption := sFile;
  i.SubItems.Add(trim(Tags.Artist));
  i.SubItems.Add(trim(Tags.Album));
  i.SubItems.Add(ZeroPad(IntToStr(Tags.Track),2));
  i.SubItems.Add(trim(Tags.Title));
  i.SubItems.Add(trim(Tags.Year));
  i.SubItems.Add(trim(Tags.Genre));
  i.SubItems.Add(trim(Tags.Comment));

  if PLFile = '' then
    PLFile := UDir + 'Playlists\' +
     SafeName(i.SubItems[siArtist] + ' - ' +
     i.SubItems[siAlbum]) + '.m3u';
end;

procedure TfrmMain.StartPlaylist;
begin
  if lvPL.Items.Count = 0 then exit;
  PLIdx := -1;
  NextTrack;
end;

procedure TfrmMain.NextTrack;
begin
  if lvPL.Items.Count = 0 then exit;
  inc(PLIdx);
  PlayFile(lvPL.Items[PLIdx].Caption,0);
end;

procedure TfrmMain.PrevTrack;
begin
  if lvPL.Items.Count = 0 then exit;
  dec(PLIdx);
  PlayFile(lvPL.Items[PLIdx].Caption,0);
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  {Speech deps: http://www.blong.com/Conferences/DCon2002/Speech/SAPI51/SAPI51.htm}
  ShowMessage(
   'Free Audio Reader - v1.78 - Freeware' + #13#13 +
   'Delphi ingredients include TMediaPlayer, TID3v1Tag, MMDevAPI, MS Speech');
end;

procedure TfrmMain.pagChange(Sender: TObject);
begin
  SetVis;
end;

procedure TfrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuOpenClick(Sender: TObject);

var n : integer;

begin
  pag.ActivePage := tabPlaylist;
  SetVis;
  dlgOpen.FilterIndex := fsAny;

  if dlgOpen.Execute then
  begin
    PLFile := '';

    for n := 0 to dlgOpen.Files.Count - 1 do
      DoFile(dlgOpen.Files[n]);
  end;
end;

procedure TfrmMain.cmdNextFileClick(Sender: TObject);
begin
  if (ss.Active) and (ss.Filename = mp.FileName) then
  begin
    cmdNextSlideClick(Self);
    exit;
  end;

  if lvPL.Items.Count > 0 then

  if PLIdx < (lvPL.Items.Count - 1) then
    NextTrack
  else if chkRepeat.Checked then
    StartPlaylist
  else
    mnuNextPlaylistClick(Self);
end;

procedure TfrmMain.cmdNextFileTRClick(Sender: TObject);

var sl : TFileStrings;
    s : string;
    n : integer;

begin
  s := ExtractFilePath(edtTRFile.Text);
  if not DirectoryExists(s) then exit;
  sl := TFileStrings.Create(s,'*.txt',true,false);

  try {refactoring w/ other prev-.next-file's}
    if sl.Count > 1 then
    begin
      n := sl.IndexOf(edtTRFile.Text);

      if (n = -1) or (n = (sl.Count - 1)) then
        n := 0
      else
        inc(n);

      if tr.Mode in [trPlay,trPause] then cmdStopTRClick(Self);
      LoadTR(sl[n],0);
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.cmdPrevFileClick(Sender: TObject);
begin
  if (ss.Active) and (ss.Filename = mp.FileName) then
  begin
    cmdPrevSlideClick(Self);
    exit;
  end;

  if PLIdx > 0 then
    PrevTrack
  else
    mnuPreviousPlaylistClick(Self);
end;

procedure TfrmMain.cmdPrevFileTRClick(Sender: TObject);

var sl : TFileStrings;
    s : string;
    n : integer;

begin
  s := ExtractFilePath(edtTRFile.Text);
  if not DirectoryExists(s) then exit;
  sl := TFileStrings.Create(s,'*.txt',true,false);

  try {refactoring w/ audio FilePrev/FileNext when not so lazy}
    if sl.Count > 1 then
    begin
      n := sl.IndexOf(edtTRFile.Text);

      if n < 1 then
        n := sl.Count - 1
      else
        dec(n);

      if tr.Mode in [trPlay,trPause] then cmdStopTRClick(Self);
      LoadTR(sl[n],0);
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.cmdNextIdxClick(Sender: TObject);
begin
  if (ss.Active) and (ss.Filename = mp.FileName) then
  begin
    cmdNextSSIdxClick(Self);
    exit;
  end;

  if tbPosition.Position < (tbPosition.Max - 15000) then
    tbPosition.Position := tbPosition.Position + 15000;
end;

procedure TfrmMain.cmdNextIdxTRClick(Sender: TObject);
begin
  if tr.Mode = trStop then exit;
  spv.Skip('Sentence',5);
end;

procedure TfrmMain.cmdPrevIdxClick(Sender: TObject);
begin
  if (ss.Active) and (ss.Filename = mp.FileName) then
  begin
    cmdPrevSSIdxClick(Self);
    exit;
  end;

  if tbPosition.Position >= 15000 then
    tbPosition.Position := tbPosition.Position - 15000
  else
    tbPosition.Position := 0;
end;

procedure TfrmMain.cmdPrevIdxTRClick(Sender: TObject);
begin
  if tr.Mode = trStop then exit;
  spv.Skip('Sentence',-5);
end;

procedure TfrmMain.mnuDocumentationClick(Sender: TObject);
begin
  RunAssoc(HDir + 'FAR_Documentation.rtf');
end;

procedure TfrmMain.mnuDynamicWallpaperClick(Sender: TObject);
begin
  mnuDynamicWallpaper.Checked := (not mnuDynamicWallpaper.Checked);
  mnuPopDynamicWallpaper.Checked := mnuDynamicWallpaper.Checked;
end;

procedure TfrmMain.DoFile(sFile : string);
begin
  if (not (FileExists(sFile))) and (DirectoryExists(sFile)) then
    GetFolderMedia(sFile)
  else if lowercase(ExtractFileExt(sFile)) = '.m3u' then
    LoadPlaylist(sFile)
  else if lowercase(ExtractFileExt(sFile)) = '.fbm' then
    LoadBookmark(sFile)
  else if lowercase(ExtractFileExt(sFile)) = '.fss' then
    LoadSS(sFile,1)
  else if lowercase(ExtractFileExt(sFile)) = '.txt' then
    LoadTR(sFile,0)
  else
    AddTrack(lvPL,sFile);{fsb also}

  if (lvPL.Items.Count > 0) and
   (not (mp.Mode in [mpPlaying,mpPaused])) then
    cmdPlayPauseClick(Self);
end;

procedure TfrmMain.AskToBuild;
begin
  if not Confirm('FAR','No playlists found - launch the playlist builder?') then exit;
  mnuBuildFoldersClick(Self);
end;

procedure TfrmMain.LoadBookmark(sFile : string);

var sl : TStringList;
    AudioPos,TextPos,ViewPos,SSPos : integer;
    sPL,k,AudFile,TxtFile,SSFile : string;

begin
  sPL := '';
  AudFile := '';
  TxtFile := '';
  SSFile := '';
  TextPos := 1;
  SSPos := 1;
  sl := TStringList.Create;
  if pos(':',sFile) = 0 then sFile := HDir + sFile;

  try
    sl.LoadFromFile(sFile);
    k := sl.Values['#Volume'];
    if k <> '' then tbVolume.Position := StrToInt2(k);
    sPL := sl.Values['#Playlist'];

    if (sl.Count > 0) and
      (copy(sl[sl.Count - 1],1,1) <> '#') then {m3u}
    begin
      AudioPos := StrToInt2(sl.Values['#FilePos']);
      AudFile := sl[sl.Count - 1];
    end
    else
    begin
      AudioPos := StrToInt2(sl.Values['#AudioPos']);
      TextPos := StrToInt2(sl.Values['#TextPos']);
      ViewPos := StrToInt2(sl.Values['#ViewPos']);
      SSPos := StrToInt2(sl.Values['#SSPos']);
      AudFile := sl.Values['#AudioFile'];
      TxtFile := sl.Values['#TextFile'];
      SSFile := sl.Values['#SSFile'];
      if pos(':',SSFile) = 0 then SSFile := HDir + SSFile;
    end;

    if FileExists(AudFile) then
    begin
      PlayFile(AudFile,AudioPos);

      if sPL = '' then
        AddTrack(lvPL,AudFile)
      else
        LoadPlaylist(sPL);

      PLIdx := GetTrackIdx(AudFile);
      SetCurrentFile;
    end;

    if (sPL <> '') and (pos(':',sPL) = 0) then
      LoadPlaylist(HDir + sPL);

    if FileExists(SSFile) then
      LoadSS(SSFile,SSPos);

    if FileExists(TxtFile) then
    begin
      LoadTR(TxtFile,ViewPos);
    end;
  except
    ShowMessage('Error loading bookmark.');
  end;

  sl.Free;
end;

function TfrmMain.GetTrackIdx(sFile : string) : integer;

var n : integer;

begin
  Result := -1;

  for n := 0 to lvPL.Items.Count - 1 do
  begin
    if lvPL.Items[n].Caption = sFile then
    begin
      Result := n;
      break;
    end;
  end;
end;

procedure TfrmMain.SetCurrentFile;

var n : integer;

begin
  if pag.ActivePage = tabTags then LoadEditTags;
  edtImgDir.Text := ExtractFilePath(mp.FileName);

  for n := 0 to lvPL.Items.Count -1 do
    lvPL.Items[n].Selected := false;

  for n := 0 to lvPL.Items.Count -1 do
    if lvPL.Items[n].Caption = mp.Filename then
      lvPL.Items[n].Selected := true;

  if (lvPL.Visible) and
   (pnlLeft.Visible) and
   (pag.ActivePage = tabPlaylist) then
  begin
    if lvPL.Selected <> nil then
      lvPL.Selected.MakeVisible(false);

    lvPL.SetFocus;
  end;
end;

procedure TfrmMain.LoadPlaylist(sFile : string);

var sl : TStringList;
    n : integer;
    b : boolean;

begin
  if not FileExists(sFile) then
  begin
    ShowMessage(sFile + #13#13 + 'Playlist not found.');
    exit;
  end;

  sb.Panels[2].Text := 'Loading ' + StripExt(ExtractFilename(sFile));
  sb.Update;
  b := false;
  PLFile := sFile;
  sl := TStringList.Create;
  lvPL.Items.BeginUpdate;

  try
    sl.LoadFromFile(sFile);

    for n := 0 to sl.Count - 1 do
    begin
      if copy(sl[n],1,1) <> '#' then
      begin {OS req order; compiler didn't care}
        if FileExists(ExtractFilePath(sFile) + sl[n]) then
          AddTrack(lvPL,ExtractFilePath(sFile) + sl[n])
        else if FileExists(sl[n]) then
          AddTrack(lvPL,sl[n])
        else
          b := true;
      end;
    end;

    if not b then b := sl.Count = 0;
  finally
    sl.Free;
    lvPL.Items.EndUpdate;
  end;

  if b then FixPlaylist(sFile);

  if mp.Mode = mpPlaying then {resuming bookmark}
    PLIdx := GetTrackIdx(mp.FileName)
  else
    StartPlaylist;

  sb.Panels[2].Text := 'Loaded: ' + StripExt(ExtractFilename(sFile));
end;

procedure TfrmMain.lvPLColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = sr.PLSortCol then
    sr.PLAsc := not sr.PLAsc
  else
    sr.PLSortCol := Column.Index;

  TListView(Sender).CustomSort(@SortByColumn,Column.Index);
end;

procedure TfrmMain.lvPLDblClick(Sender: TObject);
begin
  if lvPL.Selected = nil then exit;
  PLIdx := lvPL.ItemIndex - 1;
  NextTrack;
end;

procedure TfrmMain.PlayFile(sFile : string; StartPos : dword);

var s : string;
    nIdx : integer;

begin
  if mp.Mode in [mpPlaying,mpPaused] then mp.Stop;
  mp.Close;

  if lowercase(ExtractFileExt(sFile)) = '.fsb' then
  begin
    PlaySB(sFile);
    exit;
  end;

  mp.FileName := sFile;
  SetCurrentFile;

  try
    mp.Open;
  except
    begin
      if frmSplash <> nil then
      begin
        frmSplash.Hide;
        frmSplash.Free;
      end;

      ShowMessage(sFile + #13#13 + 'Media file error.');
      bSetting := false;
      exit;
    end;
  end;

  bSetting := true;
  tbPosition.Max := mp.Length;
  tbPosition.Position := StartPos;
  bSetting := false;

  if lowercase(ExtractFileExt(sFile)) = '.mp3' then
  begin
    s := PrettyMS(mp.Length);
    Tags.LoadFromFile(sFile);

    if (mnuAddDurComment.Checked) and
     (pos(s,Tags.Comment) = 0) then
    begin
      if trim(Tags.Comment) = '' then
        Tags.Comment := s
      else
        Tags.Comment := trim(Tags.Comment) + ' (' + s + ')';

      nIdx := GetTrackIdx(sFile);
      if nIdx > -1 then lvPL.Items[nIdx].SubItems[siComment] := Tags.Comment;

      mp.Close;
      Tags.SaveToFile(sFile);
      mp.Open;
    end;
  end;

  mp.StartPos := StartPos;
  mp.Play;
  SetPlayCap(csMP,false);
  sb.Panels[0].Text := 'Playing';

  if trim(Tags.Artist + Tags.Album) = '' then
    sb.Panels[2].Text := copy(ExtractFilePath(sFile),4,99)
  else
    sb.Panels[2].Text := trim(Tags.Artist) + ' - ' + trim(Tags.Album);

  if trim(Tags.Title) > '' then
    sb.Panels[2].Text := sb.Panels[2].Text + ' - ' +
     ZeroPad(IntToStr(Tags.Track),2) + ' - ' + trim(Tags.Title)
  else
    sb.Panels[2].Text := sb.Panels[2].Text + ' - ' +
     StripExt(ExtractFilename(sFile));

  Caption := 'FAR - ' + sb.Panels[2].Text;
  if not ss.Active then SetPic('');
  tmrTrack.Enabled := true;
end;

procedure TfrmMain.mnuViewPlaylistQueueClick(Sender: TObject);
begin
  pag.ActivePage := tabPlaylist;
  SetVis;
end;

procedure TfrmMain.mnuViewSlideShowsClick(Sender: TObject);
begin
  pag.ActivePage := tabSlideShow;
  SetVis;
end;

procedure TfrmMain.mnuViewSoundBitesClick(Sender: TObject);
begin
  pag.ActivePage := tabSoundBites;
  SetVis;
end;

procedure TfrmMain.mnuViewTagsClick(Sender: TObject);
begin
  pag.ActivePage := tabTags;
  SetVis;
end;

procedure TfrmMain.mnuViewTextReaderClick(Sender: TObject);
begin
  pag.ActivePage := tabTextReader;
  SetVis;
end;

procedure TfrmMain.SetPic(sFile : string);

var sl : TStringList;
    n : integer;
    i : TImage;
    li : TListItem;

begin
  if sFile = '' then
  begin
    ImgFile := '';
    sl := TFileStrings.Create(ExtractFilePath(mp.Filename),'*.jpg',true,false);
    lvImg.Items.Clear;
    i := TImage.Create(Self);
    i.Parent := Self;
    i.Visible := false;
    lvImg.Items.BeginUpdate;

    try
      for n := 0 to sl.Count - 1 do
      begin
        try i.Picture.LoadFromFile(sl[n]); except end;
        li := lvImg.Items.Add;

        li.Caption :=
         PadL(IntToStr(i.Picture.Height),4) + ' x' +
         PadL(IntToStr(i.Picture.Width),4);

        li.SubItems.Add(StripExt(ExtractFilename(sl[n])));
      end;

      lvImg.Items.EndUpdate;

      if sl.Count > 0 then
        ImgFile := sl[Random(sl.Count)];
    finally
      i.Free;
      sl.Free;

      for n := 0 to lvImg.Items.Count - 1 do
      begin
        if lvImg.Items[n].SubItems[0] =
         StripExt(ExtractFilename(ImgFile)) then
        begin
          lvImg.Items[n].Selected := true;
          lvImg.Selected.MakeVisible(false);
          break;
        end;
      end;
    end;
  end
  else ImgFile := sFile;

  if FileExists(ImgFile) then
  begin
    try
      if (LastImage <> ImgFile) or
       (img.Picture.Graphic = nil) then
        img.Picture.LoadFromFile(ImgFile);
    except
    end;
  end
  else img.Picture.Graphic := nil;

  SetFloat;

  if (FileExists(ImgFile)) and
   (mnuDynamicWallpaper.Checked) then
  begin
    if (img.Picture.Width < 400) or
     (img.Picture.Height < 300) then
      SetWallpaper(ImgFile,Random(2) = 1)
    else if LastImage <> ImgFile then
      SetWallpaper(ImgFile,false);
  end;

  LastImage := ImgFile;
end;

procedure TfrmMain.tbPositionChange(Sender: TObject);

var bUsurp : boolean;

begin
  if bSetting then exit;
  if not (mp.Mode in [mpPlaying,mpPaused]) then exit;
  bUsurp := false;

  if tmrUsurp.Enabled then
  begin
    bUsurp := true;
    tmrUsurp.Enabled := false;
  end
  else tmrTrack.Enabled := false;

  mp.Close;
  mp.StartPos := tbPosition.Position;
  mp.Open;
  mp.Play;
  SetPlayCap(csMP,false);

  if bUsurp then
    tmrUsurp.Enabled := true
  else
    tmrTrack.Enabled := true;
end;

procedure TfrmMain.tbVolumeChange(Sender: TObject);
begin
  SetVolume(tbVolume.Position / 100);
end;

procedure TfrmMain.SetVolume(Vol : single);
begin
  if endpointVolume = nil then exit;
  endpointVolume.SetMasterVolumeLevelScalar(Vol,nil);
end;

procedure TfrmMain.mnuPopRepeatClick(Sender: TObject);
begin
  mnuPopRepeat.Checked := (not mnuPopRepeat.Checked);
  chkRepeat.Checked := mnuPopRepeat.Checked;
  mnuRepeat.Checked := mnuPopRepeat.Checked;
end;

procedure TfrmMain.tmrTrackTimer(Sender: TObject);

var slFile : TFileStrings;
    sl,slSort : TStringList;
    n,j : integer;

begin
  if FilesExist(HDir + 'FARQ*.que') then
  begin
    try
      slFile := TFileStrings.Create(HDir,'FARQ*.que',true,false);
      slSort := TStringList.Create;
      slSort.Sorted := true;

      try
        for n := 0 to slFile.Count - 1 do
        begin
          sl := TStringList.Create;

          try
            sl.LoadFromFile(slFile[n]);
            DeleteFile(slFile[n]);

            for j := 0 to sl.Count - 1 do
              slSort.Add(sl[j]);

            for j := 0 to slSort.Count - 1 do
              DoFile(slSort[j]);
          finally
            sl.Free;
          end;
        end;
      finally
        slSort.Free;
        slFile.Free;
      end;
    except
    end;
  end;

  if SampleRec.Sampling then
  begin
    Sample;
    exit;
  end;

  if mnuCoverArtSlideshow.Checked then
  begin
    inc(ss.CoverArtWait);

    if ss.CoverArtWait >= 6 then
    begin
      ss.CoverArtWait := 0;
      SetPic('');
    end;
  end;

  if (ss.Active) and (lvSS.Items.Count > 0) then
  begin
    if cmdPlaySS.Caption = 'Pause' then
    begin
      inc(ss.Wait);
      sb.Panels[0].Text := 'Playing';
      sb.Panels[1].Text := IntToStr(ss.Delay - ss.Wait) + 's';
      if ss.Wait >= ss.Delay then NextSS;
    end;
  end;

  if mp.Mode = mpStopped then
  begin
    if (ss.Active) and (ss.Sync <> '') and (mp.FileName = ss.Sync) then
    begin
      if (ss.Rep = -1) or (ss.RepCount < ss.Rep) then
      begin
        inc(ss.RepCount);
        PlayFile(ss.Sync,0);
      end;

      exit;
    end;

    if (PLIdx = lvPL.Items.Count - 1) or
     (lvPL.Items.Count = 0) then
    begin
      if (PLIdx = lvPL.Items.Count - 1) and
       (lvPL.Items.Count > 0) and
       (chkRepeat.Checked) then
        StartPlaylist
      else
      begin
        if not ss.Active then
        begin
          tmrTrack.Enabled := false;
          sb.Panels[0].Text := 'Stopped';
          sb.Panels[1].Text := '';
          sb.Panels[2].Text := '';
        end;

        mp.FileName := '';
        SetPlayCap(csMP,true);
      end;
    end
    else NextTrack;
  end
  else if (mp.FileName <> '') and
   (mp.Mode <> mpPaused) and
   (tbPosition.Position <> mp.Position) then
  begin
    if ss.Active then
    begin
      sb.Panels[0].Text := 'Playing';
      sb.Panels[1].Text := IntToStr(ss.Delay - ss.Wait) + 's';
    end
    else
    begin
      bSetting := true;
      tbPosition.Position := mp.Position;
      bSetting := false;
      sb.Panels[1].Text := PrettyMS(tbPosition.Position);
      sb.Panels[0].Text := 'Playing';
    end;
  end;
end;

procedure TfrmMain.CreateBookmark(AskName : string; AddVol : boolean);

var sl : TStringList;
    pct : integer;
    nPos : integer;

begin
  if mp.FileName <> '' then
  begin
    nPos := mp.Position - 5000;
    if nPos < 0 then nPos := 0;
    Tags.LoadFromFile(mp.FileName);
  end;

  if mp.Mode in [mpPlaying,mpPaused] then
  begin
    if mp.Length > 0 then
      pct := Round((mp.Position / mp.Length) * 100)
    else
      pct := 0;

    dlgSave.Filename := SafeName(trim(Tags.Artist) + ' - ' +
     trim(Tags.Album) + ' - ' +
     ZeroPad(IntToStr(Tags.Track),2) + ' - ' +
     trim(Tags.Title) + ' (' + IntToStr(pct) + '%)');
  end
  else dlgSave.Filename := '';

  if ss.Active then
    dlgSave.Filename := dlgSave.Filename +
     StripExt(ExtractFilename(
     ss.Filename)) + ' (Slide ' + IntToStr(ss.Idx + 1) +
     ' of ' + InttoStr(lvSS.Items.Count) + ')';

  if redTR.Text <> '' then
    dlgSave.Filename := dlgSave.Filename +
     StripExt(ExtractFilename(edtTRFile.Text)) +
     ' (Pos ' + IntToStr(redTR.SelStart) + ')';

  if AddVol then
    dlgSave.Filename := copy(dlgSave.Filename,1,
    Length(dlgSave.Filename) - 1) + ',v' +
    IntToStr(tbVolume.Position) + ')';

  dlgSave.InitialDir := UDir + 'Bookmarks';

  if AskName = '' then
  begin
    dlgSave.DefaultExt := 'fbm';
    if not dlgSave.Execute then exit;
  end
  else dlgSave.Filename := dlgSave.InitialDir + '\' + AskName;

  if (PLFile <> '') and (not FileExists(PLFile)) then
    SavePlaylist;

  sl := TStringList.Create;

  try
    sl.Add('#Playlist=' + PLFile);

    if AddVol then
      sl.Add('#Volume=' + IntToStr(tbVolume.Position));

    if ss.Active then
    begin
      sl.Add('#SSPos=' + IntToStr(ss.Idx + 1));
      sl.Add('#SSFile=' + ss.FileName);
    end;

    if redTR.Text <> '' then
    begin
      sl.Add('#TextPos=' + IntToStr(tr.Skips));
      sl.Add('#TextFile=' + edtTRFile.Text);
      sl.Add('#ViewPos=' + IntToStr(redTR.SelStart));
    end;

    if mp.FileName <> '' then
    begin
      sl.Add('#AudioPos=' + IntToStr(nPos));
      sl.Add('#AudioFile=' + mp.FileName);
    end;

    sl.SaveToFile(dlgSave.Filename);

    sb.Panels[2].Text := 'Bookmark created: ' +
     StripExt(ExtractFilename(dlgSave.Filename));
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.mnuAddbookmarkClick(Sender: TObject);
begin
  if (not ss.Active) and
   (redTR.Text = '') and
   (not (mp.Mode in [mpPlaying,mpPaused])) then
  begin
    ShowMessage('Nothing to bookmark.');
    exit;
  end;

  CreateBookmark('',false);
end;

procedure TfrmMain.mnuAddDurCommentClick(Sender: TObject);
begin
  mnuAddDurComment.Checked := (not mnuAddDurComment.Checked);
  mnuPopAddDurComment.Checked := mnuAddDurComment.Checked;
end;

procedure TfrmMain.mnuBookmarkVolumeClick(Sender: TObject);
begin
  if (not ss.Active) and
   (mp.FileName = '') and
   (edtTRFile.Text = '') then
  begin
    ShowMessage('Open a file first.');
    exit;
  end;

  CreateBookmark('',true);
end;

procedure TfrmMain.mnuGotobookmarkClick(Sender: TObject);
begin
  dlgOpen.InitialDir := UDir + 'Bookmarks';
  dlgOpen.FilterIndex := fsBookmark;
  if not dlgOpen.Execute then exit;
  Caption := 'FAR';
  cmdStopClick(Self);
  lvPL.Items.Clear;
  LoadBookmark(dlgOpen.Filename);
end;

procedure TfrmMain.mnuNewPLClick(Sender: TObject);
begin
  Caption := 'FAR';
  PLFile := '';
  lvPL.Items.Clear;
  cmdAddPLClick(Self);
  SavePlaylist;
  StartPlaylist;
end;

procedure TfrmMain.mnuPlayPLClick(Sender: TObject);

var n : integer;

begin
  dlgOpen.InitialDir := UDir + 'Playlists';
  dlgOpen.FilterIndex := fsPlaylist;
  if not dlgOpen.Execute then exit;
  if mp.Mode in [mpPlaying,mpPaused] then mp.Stop;
  PLIdx := -1;
  PLFile := '';
  lvPL.Items.Clear;

  for n := 0 to dlgOpen.Files.Count - 1 do
    DoFile(dlgOpen.Files[n]);
end;

procedure TfrmMain.mnuRepeatClick(Sender: TObject);
begin
  mnuRepeat.Checked := (not mnuRepeat.Checked);
  chkRepeat.Checked := mnuRepeat.Checked;
  mnuPopRepeat.Checked := mnuRepeat.Checked;
end;

procedure TfrmMain.mnuRepeatSSClick(Sender: TObject);
begin
  if bSetting then exit;
  mnuRepeatSS.Checked := (not mnuRepeatSS.Checked);
  bSetting := true;
  chkRepeatSS.Checked := mnuRepeatSS.Checked;
  bSetting := false;
  mnuPopRepeatSS.Checked := mnuRepeatSS.Checked;
end;

procedure TfrmMain.mnuCoverArtSlideshowClick(Sender: TObject);
begin
  mnuCoverArtSlideshow.Checked := (not mnuCoverArtSlideshow.Checked);
  mnuPopCoverArtSlideshow.Checked := mnuCoverArtSlideshow.Checked;
end;

procedure TfrmMain.mnuSaveAsClick(Sender: TObject);
begin
  if lvPL.Items.Count = 0 then exit;
  dlgSave.InitialDir := UDir + 'Playlists';
  dlgSave.Filename := '';
  dlgSave.DefaultExt := 'm3u';
  if not dlgSave.Execute then exit;
  PLFile := dlgSave.Filename;
  SavePlaylist;
end;

procedure TfrmMain.mnuSaveClick(Sender: TObject);
begin
  if lvPL.Items.Count = 0 then exit;

  if PLFile = '' then
  begin
    dlgSave.InitialDir := UDir + 'Playlists';

    if lvPL.Items.Count > 0 then
      dlgSave.Filename := SafeName(lvPL.Items[0].SubItems[0] + ' - ' + lvPL.Items[0].SubItems[1])
    else
      dlgSave.Filename := '';

    dlgSave.DefaultExt := 'm3u';
    if not dlgSave.Execute then exit;
    PLFile := dlgSave.Filename;
  end;

  SavePlaylist;
end;

procedure TfrmMain.mnuVolUpClick(Sender: TObject);
begin
  if tbVolume.Position > 90 then
    tbVolume.Position := 100
  else
    tbVolume.Position := tbVolume.Position + 10;
end;

procedure TfrmMain.mnuVolDownClick(Sender: TObject);
begin
  if tbVolume.Position < 10 then
    tbVolume.Position := 0
  else
    tbVolume.Position := tbVolume.Position - 10;
end;

procedure TfrmMain.SavePlaylist;

var n : integer;
    sl : TStringList;

begin
  if lvPL.Items.Count = 0 then
  begin
    DeleteFile(PLFile);
    exit;
  end;

  if PLFile = '' then
    PLFile := UDir + 'Playlists\' +
     SafeName(lvPL.Items[0].SubItems[siArtist] + ' - ' +
     lvPL.Items[0].SubItems[siAlbum]) + '.m3u';

  if ExtractFilename(PLFile) = ' - .m3u' then exit;
  sl := TStringList.Create;

  try
    for n := 0 to lvPL.Items.Count - 1 do
      sl.Add(lvPL.Items[n].Caption);

    sl.SaveToFile(PLFile);
  except
  end;

  sl.Free;
  sb.Panels[2].Text := 'Playlist saved: ' + ExtractFilename(PLFile);
end;

function TfrmMain.GetFolderMedia(sDir : string) : boolean;

var sl : TFileStrings;
    n : integer;

begin
  Result := false;
  if lvPL.Items.Count = 0 then PLIdx := -1;
  sb.Panels[2].Text := 'Scanning files..';
  sb.Update;
  sl := TFileStrings.Create(sDir,'*.*',true,true);
  lvPL.Items.BeginUpdate;

  try
    for n := sl.Count - 1 downto 0 do
    begin
      if InStrSet(lowercase(ExtractFileExt(sl[n])),
       '.mp3,.wma,.wav,.mid,.fsb') then
        Result := true
      else
        sl.Delete(n);
    end;

    sl.Sort;

    for n := 0 to sl.Count - 1 do
      AddTrack(lvPL,sl[n]);
  finally
    sl.Free;
    sb.Panels[2].Text := 'Finished adding to unsaved playlist.';
    lvPL.Items.EndUpdate;
  end;
end;

procedure TfrmMain.chkRepeatClick(Sender: TObject);
begin
  mnuRepeat.Checked := chkRepeat.Checked;
  mnuPopRepeat.Checked := chkRepeat.Checked;
end;

procedure TfrmMain.cmdAddPLClick(Sender: TObject);

var Root : string;

begin
  Root := GetDirectory('Add to Playlist');
  if Root = '' then exit;

  if not GetFolderMedia(Root) then
    ShowMessage('No valid media files found.');
end;

procedure TfrmMain.cmdRemovePLClick(Sender: TObject);

var n : integer;

begin
  if lvPL.Selected = nil then exit;
  n := lvPL.ItemIndex;
  lvPL.DeleteSelected;
  PLIdx := GetTrackIdx(mp.FileName);
  if n >= lvPL.Items.Count then n := lvPL.Items.Count - 1;
  if n >= 0 then lvPL.Items[n].Selected := true;
  if pag.ActivePage = tabPlaylist then lvPL.SetFocus;
end;

procedure TfrmMain.cmdMoveUpClick(Sender: TObject);
begin
  if lvPL.ItemIndex = -1 then exit;
  if lvPL.ItemIndex = 0 then exit;
  ExchangeItems(lvPL,lvPL.ItemIndex - 1);
  if PLIdx = (lvPL.ItemIndex + 1) then dec(PLIdx);
  if (lvPL.Visible) and (pag.ActivePage = tabPlaylist) then lvPL.SetFocus;
end;

procedure TfrmMain.cmdMoveDownClick(Sender: TObject);
begin
  if lvPL.ItemIndex = -1 then exit;
  if lvPL.ItemIndex = lvPL.Items.Count - 1 then exit;
  ExchangeItems(lvPL,lvPL.ItemIndex + 1);
  if PLIdx = (lvPL.ItemIndex - 1) then inc(PLIdx);
  if (lvPL.Visible) and (pag.ActivePage = tabPlaylist) then lvPL.SetFocus;
end;

procedure TfrmMain.ExchangeItems(lv : TListView; const n2 : integer);

var i : TListItem;
    n : integer;

begin
  n := lv.ItemIndex;
  i := TListItem.Create(lv.Items);

  try
    i.Assign(lv.Items[n]);
    lv.Items[n].Assign(lv.Items[n2]);
    lv.Items[n2].Assign(i);
    lv.ClearSelection;
    lv.Selected := lv.Items[n2];
  finally
    i.Free;
  end;
end;

procedure TfrmMain.LoadEditTags;
begin
  Tags.LoadFromFile(edtTagFile.Text);
  edtArtist.Text := trim(Tags.Artist);
  edtAlbum.Text := trim(Tags.Album);
  edtTitle.Text := trim(Tags.Title);
  edtComment.Text := trim(Tags.Comment);
  spnTrack.Value := Tags.Track;
  edtYear.Text := trim(Tags.Year);
  cmbGenre.Text := Tags.Genre;
end;

procedure TfrmMain.cmdReloadTagsClick(Sender: TObject);
begin
  LoadEditTags;
end;

procedure TfrmMain.ShuffleLV(lv : TListView);

var n,r,q : integer;
    s : string;

begin
  Enabled := false;
  lv.Items.BeginUpdate;
  q := lv.Items.Count - 1;
  if q > 99 then q := 99;
  bSetting := true;

  try
    for n := 0 to q do
    begin
      repeat
        r := Random(lv.Items.Count);
      until r <> n;

      lv.ItemIndex := n;
      ExchangeItems(lv,r);
      s := IntToStr(Round(((n + 1) / lv.Items.Count) * 100));
      sb.Panels[2].Text := 'Shuffling (' + s + '%)';
      sb.Update;
    end;
  finally
    bSetting := false;
    Enabled := true;
    lv.Items.EndUpdate;
  end;
end;

procedure TfrmMain.cmdShuffleClick(Sender: TObject);
begin
  if lvPL.Items.Count < 2 then exit;
  ShuffleLV(lvPL);
  StartPlaylist;
end;

procedure TfrmMain.cmdStopClick(Sender: TObject);
begin
  tmrTrack.Enabled := false;
  if mp.Mode in [mpPlaying,mpPaused] then mp.Stop;
  SampleRec.Sampling := false;
  mnuSample.Checked := false;
  mnuPopSample.Checked := false;
  tbPosition.Position := 0;
  SetPlayCap(csMP,true);
  sb.Panels[0].Text := 'Stopped';
  mp.FileName := '';
  mp.Close;
  PLIdx := -1;

  if (ss.Active) and
   (ss.Filename = mp.FileName) then
    cmdStopSSClick(Self);

  if tr.Mode = trPlay then
    cmdStopTRClick(Self);
end;

procedure TfrmMain.mnuMixerClick(Sender: TObject);
begin
  RunCPL('MMSys.cpl','');
end;

procedure TfrmMain.Usurp(Start : boolean);
begin
  if Start then
  begin
    ump.Filename := mp.Filename;
    ump.Mode := mp.Mode;
    ump.Position := mp.Position;
    ump.CmdCap := cmdPlayPause.Caption;
    mp.Close;
  end
  else if lvPL.FindCaption(0,ump.Filename,false,true,false) <> nil then
  begin
    cmdPlayPause.Caption := ump.CmdCap;
    mp.Close;
    mp.Filename := ump.Filename;
    mp.Open;
    mp.Position := ump.Position;

    if ump.Mode = mpPlaying then
      mp.Play;
  end;
end;

procedure TfrmMain.UpdateTags(sFile : string);

var nIdx : integer;

begin
  if lowercase(ExtractFileExt(sFile)) <> '.mp3' then
  begin
    sb.Panels[2].Text := 'Only MP3 tags are supported.';
    exit;
  end;

  Tags.Artist := edtArtist.Text;
  Tags.Album := edtAlbum.Text;
  Tags.Year := edtYear.Text;
  Tags.Genre := cmbGenre.Text;
  if mp.FileName = sFile then Usurp(true);
  Tags.SaveToFile(sFile);
  nIdx := GetTrackIdx(sFile);
  lvPL.Items[nIdx].SubItems[siArtist] := trim(edtArtist.Text);
  lvPL.Items[nIdx].SubItems[siAlbum] := trim(edtAlbum.Text);
  lvPL.Items[nIdx].SubItems[siYear] := trim(edtYear.Text);
  lvPL.Items[nIdx].SubItems[siGenre] := trim(cmbGenre.Text);
  if mp.FileName = sFile then Usurp(false);
  if (bInit) and (lvPL.Visible) then lvPL.SetFocus;
end;

procedure TfrmMain.cmdSaveTagsClick(Sender: TObject);

var nIdx : integer;

begin
  pag.ActivePage := tabPlaylist;
  SetVis;
  Tags.Track := spnTrack.Value;
  Tags.Title := edtTitle.Text;
  Tags.Comment := edtComment.Text;
  nIdx := GetTrackIdx(edtTagFile.Text);
  if nIdx = -1 then exit;
  lvPL.Items[nIdx].SubItems[siTrack] := ZeroPad(IntToStr(spnTrack.Value),2);
  lvPL.Items[nIdx].SubItems[siTitle] := trim(edtTitle.Text);
  lvPL.Items[nIdx].SubItems[siComment] := trim(edtComment.Text);
  UpdateTags(edtTagFile.Text);
  tmrTrack.Enabled := true;
end;

procedure TfrmMain.cmdSavePlusClick(Sender: TObject);

var n : integer;

begin
  cmdSaveTagsClick(Self);
  tmrTrack.Enabled := false;
  lvPL.Items.BeginUpdate;

  try
    for n := 0 to lvPL.Items.Count - 1 do
    begin
      if (lvPL.Items[n].Selected) and
       (lvPL.Items[n].Caption <> edtTagFile.Text) then
      begin
        Tags.LoadFromFile(lvPL.Items[n].Caption);
        UpdateTags(lvPL.Items[n].Caption);
        Application.ProcessMessages;
      end;
    end;
  finally
    lvPL.Items.EndUpdate;
    tmrTrack.Enabled := (pag.ActivePage <> tabTags);
  end;
end;

procedure TfrmMain.cmdSaveAllTagsClick(Sender: TObject);

var n : integer;

begin
  tmrTrack.Enabled := false;
  lvPL.Items.BeginUpdate;

  try
    for n := 0 to lvPL.Items.Count - 1 do
    begin
      if lvPL.Items[n].Selected then
      begin
        edtTagFile.Text := lvPL.Items[n].Caption;
        cmdSaveTagsClick(Self);
        Application.ProcessMessages;
      end;
    end;
  finally
    lvPL.Items.EndUpdate;
    tmrTrack.Enabled := (pag.ActivePage <> tabTags);
  end;
end;

procedure TfrmMain.mnuBuildFoldersClick(Sender: TObject);

var Dir,ADir : string;
    nPL : integer;
    t : TID3v1Tag;
    bPortables : boolean;

procedure CollectDir(sDir,sPLDir : string);

var n : integer;
    sl : TStringList;
    slPL : TStringList;
    Last : string;

procedure MkPL;

var pf : string;
    z : integer;

begin
  t.LoadFromFile(slPL[0]);

  if trim(t.Artist + t.Album) <> '' then
    pf := sPLDir + SafeName(trim(t.Artist) + ' - ' + trim(t.Album))
  else
    pf := sPLDir + NoFinalBS(LastDir(ExtractFilePath(
     slPL[0]))) + ' - ' + StripExt(ExtractFilename(slPL[0]));

  pf := pf + '.m3u';
  inc(nPL);
  slPL.SaveToFile(pf);

  if bPortables then
  begin
    pf := ExtractFilePath(slPL[0]) + ExtractFilename(pf);

    for z := 0 to slPL.Count - 1 do
      slPL[z] := ExtractFilename(slPL[z]);

    inc(nPL);
    slPL.SaveToFile(pf);
  end;

  slPL.Clear;
  sb.Panels[2].Text := 'Created playlist: ' + StripExt(ExtractFilename(pf));
end;

begin {CollectDir}
  Last := '';
  sl := TFileStrings.Create(sDir,'*.*',true,true);
  slPL := TStringList.Create;

  try
    for n := 0 to sl.Count - 1 do
    begin
      if not bBuild then break;

      if (slPL.Count > 0) and
       (Last <> '') and
       (Last <> ExtractFilePath(sl[n])) then
        MkPL;

      Last := ExtractFilePath(sl[n]);

      if InStrSet(lowercase(copy(sl[n],
       Length(sl[n]) - 3,4)),'.mp3,.wma,.wav,.mid,.fsb') then
        slPL.Add(sl[n]);

      Application.ProcessMessages;
    end;

    if slPL.Count > 0 then MkPL;
  finally
    sl.Free;
    slPL.Free;
  end;
end;

begin {mnuBuildFoldersClick}
  if bBuild then
  begin
    if Confirm('FAR','Cancel build?') then
    begin
      bBuild := false;
      mnuBuildFolders.Caption := '&One playlist per folder';
      exit;
    end
    else exit;
  end;

  Dir := GetDirectory('MUSIC base folder (or Esc)');
  ADir := GetDirectory('AUDIOBOOK base folder (or Esc)');
  bPortables := Confirm('FAR','Also create portable playlists?');
  nPL := 0;
  bBuild := true;
  sb.Panels[0].Text := 'Build';
  sb.Panels[2].Text := 'Scanning folders...';
  mnuBuildFolders.Caption := '&Cancel Build';
  mnuPopOnePlaylistPerFolder.Caption := '&Cancel Build';
  t := TID3v1Tag.Create;

  try
    if Dir <> '' then
      CollectDir(Dir,UDir + 'Playlists\');

    if (ADir <> '') and (bBuild) then
      CollectDir(ADir,UDir + 'Playlists\Audiobooks\');
  finally
    if t <> nil then FreeAndNil(t);
    bBuild := false;
    sb.Panels[0].Text := 'Ready';
    sb.Panels[2].Text := 'Created ' + CommaStr(IntToStr(nPL)) + ' playlists.';
    mnuBuildFolders.Caption := '&One Playlist Per Folder';
    mnuPopOnePlaylistPerFolder.Caption := mnuBuildFolders.Caption;
  end;
end;

procedure TfrmMain.cmdJukeboxClick(Sender: TObject);

var sl,slFile : TStringList;
    slPL : TFileStrings;
    n,j,r : integer;

begin
  slPL := TFileStrings.Create(UDir + 'Playlists','*.m3u',true,false);

  for n := slPL.Count - 1 downto 0 do
  begin
    if InStrSet(copy(ExtractFilename(slPL[n]),1,8),
     'Bookmark,Jukebox ') then
      slPL.Delete(n);
  end;

  if slPL.Count = 0 then
  begin
    slPL.Free;
    AskToBuild;
    exit;
  end;

  sb.Panels[0].Text := 'Busy';
  sb.Panels[1].Text := '- - -';
  sb.Panels[2].Text := 'Creating mix...';
  sb.Update;
  pag.ActivePage := tabPlaylist;
  PLFile := UDir + 'Playlists\Jukebox Mix ' + FormatDateTime('ddd, mmm dd, yyyy',Now) + '.m3u';
  lvPL.Items.Clear;
  sl := TStringList.Create;
  slFile := TStringList.Create;

  try
    for n := 0 to slPL.Count - 1 do
    begin
      slFile.LoadFromFile(slPL[n]);

      for j := 0 to slFile.Count - 1 do
        if (copy(slFile[j],1,1) <> '#') and
         (FileExists(slFile[j])) then
          sl.Add(slFile[j]);
    end;

    for n := 1 to 99 do
    begin
      if sl.Count = 0 then break;
      r := Random(sl.Count);
      AddTrack(lvPL,sl[r]);
      sl.Delete(r);
    end;

    if lvPL.Items.Count = 0 then
      AskToBuild
    else
      mnuSaveClick(Self);
  finally
    sl.Free;
    slFile.Free;
    slPL.Free;
  end;

  StartPlaylist;
end;

procedure TfrmMain.FixPlaylist(sFile : string);

var sl : TStringList;
    n : integer;

begin
  if not FileExists(sFile) then exit;
  if frmSplash <> nil then frmSplash.Hide;
  sl := TStringList.Create;

  try
    sl.LoadFromFile(sFile);

    for n := lvPL.Items.Count - 1 downto 0 do
      if (copy(sl[n],1,1) <> '#') and (not FileExists(sl[n])) then
        sl.Delete(n);

    if sl.Count > 0 then
      sl.SaveToFile(sFile)
    else
      DeleteFile(sFile);
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.GetArt(Dir,Title : string);

const ScrURL1 = 'http://www.google.com/images?um=1&hl=en&sa=1&q=cover%3A+';
      ScrURL2 = '&btnG=Search';

var sl : TStringList;
    sBlob : string;
    z : integer;
    slPics : TStringList;

procedure EatPics(var s : string);

var n : integer;
    ss : string;

begin
  ss := '';

  for n := (pos('.jpg',s) + 3) downto 1 do
  begin
    ss := s[n] + ss;
    if copy(ss,1,5) = 'http:' then break;
  end;

  if copy(ss,1,5) = 'http:' then
  begin
    slPics.Add(ss);

    System.Delete(s,
     (pos('.jpg',s) + 3) - Length(ss),
     Length(ss));
  end;
end;

begin {GetArt}
  GetURL(TmpFile,ScrURL1 + URLStr(Title) + ScrURL2);
  if not FileExists(TmpFile) then exit;
  sl := TStringList.Create;
  slPics := TStringList.Create;
  slPics.Sorted := true;
  slPics.Duplicates := dupIgnore;

  try
    sl.LoadFromFile(TmpFile);
    sBlob := sl.Text;
    while pos('.jpg',sBlob) > 0 do EatPics(sBlob);

    for z := 0 to slPics.Count - 1 do
    begin
      sb.Panels[2].Text := 'Downloading image ' +
       IntToStr(z + 1) + '/' +
       IntToStr(slPics.Count) + ' for ' + Title;

      sb.Update;
      Application.ProcessMessages;
      if not bBuildArt then break;
      sBlob := SerFile(FinalBS(Dir) + SafeName(Title) + '.jpg');
      GetURL(sBlob,slPics[z]);
      SetPic('');{''=relist}
    end;
  finally
    sl.Free;
    slPics.Free;
  end;
end;

procedure TfrmMain.mnuChangeArtClick(Sender: TObject);
begin
  SetPic('');
end;

procedure TfrmMain.mnuCoverArtClick(Sender: TObject);
begin
  if lvPL.Selected = nil then
  begin
    ShowMessage('Select a track with Artist/Album info first.');
    exit;
  end;

  bBuildArt := true;

  if mp.FileName = '' then
    mp.FileName := lvPL.Selected.Caption;

  try
    GetArt(ExtractFilePath(lvPL.Selected.Caption),
     lvPL.Selected.SubItems[0] + ' - ' +
     lvPL.Selected.SubItems[1]);
  finally
    bBuildArt := false;
    DeleteFile(TmpFile);
    sb.Panels[2].Text := 'Finished collecting art.';
  end;
end;

procedure TfrmMain.cmdCopyClick(Sender: TObject);

var n : integer;
    bDirs : boolean;
    Trg,Dir1,Dir2 : string;
    slPL : TStringList;

begin
  if lvPL.Items.Count = 0 then
  begin
    ShowMessage('Open or create a playlist first.');
    exit;
  end;

  Trg := GetDirectory('Output Folder');
  if Trg = '' then exit else Trg := FinalBS(Trg);
  bDirs := Confirm('FAR','Create tag-based folders?');
  mnuPlaylists.Enabled := false;
  mnuPopPlaylists.Enabled := false;
  pnlQueue.Enabled := false;
  if PLFile = '' then PLFile := 'Playlist.m3u';
  slPL := TStringList.Create;
  Usurp(true);

  try
    for n := 0 to lvPL.Items.Count - 1 do
    begin
      sb.Panels[2].Text := 'Copying ' + ExtractFilename(lvPL.Items[n].Caption);
      Application.ProcessMessages;
      slPL.Add(ExtractFilename(lvPL.Items[n].Caption));

      if bDirs then
      begin
        try
          Tags.LoadFromFile(lvPL.Items[n].Caption);
          {OS rejects periods at end; del all}
          Dir1 := Strip(trim(SafeName(Tags.Artist)),'.');
          Dir2 := Strip(trim(SafeName(Tags.Album)),'.');;

          slPL[slPL.Count - 1] :=
           Dir1 + '\' + Dir2 + '\' + slPL[slPL.Count - 1];

          if not DirectoryExists(Trg + Dir1) then
            MkDir(Trg + Dir1);

          if not DirectoryExists(Trg + Dir1 + '\' + Dir2) then
            MkDir(Trg + Dir1 + '\' + Dir2);

          CopyFile(lvPL.Items[n].Caption,
           Trg + Dir1 + '\' + Dir2 + '\' +
           ExtractFilename(lvPL.Items[n].Caption));
        except
        end;
      end
      else CopyFile(lvPL.Items[n].Caption,Trg + ExtractFilename(lvPL.Items[n].Caption));
    end;

    slPL.SaveToFile(Trg + ExtractFilename(PLFile));
    sb.Panels[2].Text := 'Playlist copied.';
  finally
    slPL.Free;
    Usurp(false);
    mnuPlaylists.Enabled := true;
    mnuPopPlaylists.Enabled := true;
    pnlQueue.Enabled := true;
  end;
end;

procedure TfrmMain.cmdGoogleClick(Sender: TObject);

var s : string;

begin
  if lvPL.ItemIndex = -1 then exit;

  s := Google + URLStr(lvPL.Selected.SubItems[0] +
   ': ' + lvPL.Selected.SubItems[1]);

  ShellExecute(WindowHandle,'open',PChar(s),nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmMain.mnuVisitGutenbergClick(Sender: TObject);
begin
  ShellExecute(WindowHandle,'open',PChar('http://www.gutenberg.org'),nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmMain.mnuVisitLibriVoxClick(Sender: TObject);
begin
  ShellExecute(WindowHandle,'open',PChar('http://librivox.org/newcatalog/genres.php'),nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmMain.mnuHomePageClick(Sender: TObject);
begin
  ShellExecute(WindowHandle,'open',PChar('http://freeaudioreader.codeplex.com'),nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmMain.mnuImageCollectorClick(Sender: TObject);
begin
  ShellExecute(0,'open',pchar(HDir + 'FIC.exe'),nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmMain.mnuImageViewerClick(Sender: TObject);
begin
  RunAssoc(ImgFile);
end;

procedure TfrmMain.lvImgSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if (ss.Active) or (Item = nil) or (not Selected) then exit;
  SetPic(ExtractFilePath(mp.FileName) + Item.SubItems[0] + '.jpg');
end;

procedure TfrmMain.lvImgColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = sr.ImgSortCol then
    sr.ImgAsc := not sr.ImgAsc
  else
    sr.ImgSortCol := Column.Index;

  TListView(Sender).CustomSort(@SortByColumn,Column.Index);
end;

procedure TfrmMain.DelPic;

var n : integer;

begin
  if not Confirm('FAR',ImgFile + #13#13 + 'Delete file?') then exit;
  DeleteFile(ImgFile);
  n := lvImg.ItemIndex;
  lvImg.DeleteSelected;
  if n = lvImg.Items.Count then dec(n);
  if n = -1 then exit;
  lvImg.ItemIndex := n;
  SetPic(ExtractFilePath(ImgFile) + lvImg.Selected.SubItems[0] + '.jpg');
  lvImg.SetFocus;
end;

procedure TfrmMain.cmdMoveImgClick(Sender: TObject);

var s : string;

begin
  if lvImg.ItemIndex = -1 then exit;
  tmrTrack.Enabled := false;
  s := GetDirectory('Move to folder');
  tmrTrack.Enabled := true;
  if s = '' then exit;
  s := s + '\' + lvImg.Selected.SubItems[0] + '.jpg';
  MoveFile(pchar(ImgFile),pchar(s));
  lvImg.DeleteSelected;
  lvImg.SetFocus;
end;

procedure TfrmMain.cmdCopyImgClick(Sender: TObject);

var s : string;

begin
  if lvImg.ItemIndex = -1 then exit;
  tmrTrack.Enabled := false;
  s := GetDirectory('Copy to folder');
  tmrTrack.Enabled := true;
  if s = '' then exit;
  s := s + '\' + lvImg.Selected.SubItems[0] + '.jpg';
  CopyFile(ImgFile,s);
  lvImg.SetFocus;
end;

procedure TfrmMain.cmdCopyTRClick(Sender: TObject);
begin
  redTR.CopyToClipboard;
end;

procedure TfrmMain.cmdDeleteImgClick(Sender: TObject);
begin
  if lvImg.ItemIndex = -1 then exit;
  DelPic;
end;

procedure TfrmMain.cmdRenameImgClick(Sender: TObject);

var s : string;

begin
  if lvImg.ItemIndex = -1 then exit;
  s := lvImg.Selected.SubItems[0];
  tmrTrack.Enabled := false;
  InputQuery('FAR','New filename (no extension)',s);
  tmrTrack.Enabled := true;
  if s = '' then exit;
  RenameFile(ImgFile,ExtractFilePath(ImgFile) + s + '.jpg');
  lvImg.Selected.SubItems[0] := s;
end;

procedure TfrmMain.mnuReseqTrackClick(Sender: TObject);

var n,nTrack : integer;
    s : string;

begin
  if lvPL.Selected = nil then exit;
  s := '';
  InputQuery('Resequence Selected Track# Tags','Starting Track#',s);
  if s = '' then exit;
  tmrTrack.Enabled := false;
  lvPL.Items.BeginUpdate;

  try
    nTrack := StrToInt2(s) - 1;

    for n := 0 to lvPL.Items.Count - 1 do
    begin
      if lvPL.Items[n].Selected then
      begin
        if mp.FileName = lvPL.Items[n].Caption then
          Usurp(true);

        inc(nTrack);
        Tags.LoadFromFile(lvPL.Items[n].Caption);
        Tags.Track := nTrack;
        Tags.SaveToFile(lvPL.Items[n].Caption);
        lvPL.Items[n].SubItems[2] := ZeroPad(IntToStr(nTrack),2);
        Application.ProcessMessages;
      end;
    end;

    Usurp(false);
  finally
    tmrTrack.Enabled := (pag.ActivePage <> tabTags);
    lvPL.Items.EndUpdate;
  end;
end;

procedure TfrmMain.mnuFindClick(Sender: TObject);
begin
  if lvPL.Items.Count = 0 then exit;
  InputQuery('FAR','Look for:',sFind);
  if sFind = '' then exit;
  sFind := lowercase(sFind);
  FindMatches(0);
end;

procedure TfrmMain.mnuFindCurrentClick(Sender: TObject);

var n : integer;

begin
  if not (mp.Mode in [mpPaused,mpPlaying]) then
  begin
    sb.Panels[2].Text := 'No paused or playing track.';
    exit;
  end;

  for n := 0 to lvPL.Items.Count - 1 do
    lvPL.Items[n].Selected := (mp.FileName = lvPL.Items[n].Caption);

  pag.ActivePage := tabPlaylist;
  SetVis;
  if lvPL.Selected <> nil then lvPL.Selected.MakeVisible(false);
end;

procedure TfrmMain.mnuFindNextClick(Sender: TObject);
begin
  if lvPL.Items.Count < 2 then exit;
  if lvPL.ItemIndex = -1 then lvPL.ItemIndex := 0;
  FindMatches(lvPL.ItemIndex + 1);
end;

procedure TfrmMain.FindMatches(Idx : integer);

var n : integer;
    s : string;
    b : boolean;

begin
  sb.Panels[2].Text := '';

  if (Idx < 0) or (Idx >= lvPL.Items.Count) then
  begin
    sb.Panels[2].Text := 'Not found.';
    exit;
  end;

  b := false;
  mnuViewNormalClick(Self);
  pag.ActivePage := tabPlaylist;
  SetVis;
  lvPL.ClearSelection;

  for n := Idx to lvPL.Items.Count - 1 do
  begin
    s := lvPL.Items[n].Caption +
     lvPL.Items[n].SubItems[siArtist] +
     lvPL.Items[n].SubItems[siAlbum] +
     lvPL.Items[n].SubItems[siTrack] +
     lvPL.Items[n].SubItems[siTitle] +
     lvPL.Items[n].SubItems[siYear] +
     lvPL.Items[n].SubItems[siGenre] +
     lvPL.Items[n].SubItems[siComment];

    if pos(sFind,lowercase(s)) > 0 then
    begin
      b := true;
      lvPL.ItemIndex := n;
      lvPL.Items[n].MakeVisible(false);
      lvPL.SetFocus;
      break;
    end;

    Application.ProcessMessages;
  end;

  if not b then sb.Panels[2].Text := 'No matches found.';
end;

procedure TfrmMain.mnuPreviousPlaylistClick(Sender: TObject);

var sl : TFileStrings;
    s : string;
    n : integer;

begin
  s := ExtractFilePath(PLFile);
  if not DirectoryExists(s) then exit;
  sl := TFileStrings.Create(s,'*.m3u',true,false);

  try
    if sl.Count > 1 then
    begin
      n := sl.IndexOf(PLFile);

      if n < 1 then
        n := sl.Count - 1
      else
        dec(n);

      if mp.Mode in [mpPlaying,mpPaused] then mp.Stop;
      mp.Close;
      lvPL.Items.Clear;
      LoadPlaylist(sl[n]);
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.mnuNextPlaylistClick(Sender: TObject);

var sl : TFileStrings;
    s : string;
    n : integer;

begin
  s := ExtractFilePath(PLFile);
  if not DirectoryExists(s) then exit;
  sl := TFileStrings.Create(s,'*.m3u',true,false);

  try {refactoring w/ other prev-.next-file's}
    if sl.Count > 1 then
    begin
      n := sl.IndexOf(PLFile);

      if (n = -1) or (n = (sl.Count - 1)) then
        n := 0
      else
        inc(n);

      if mp.Mode in [mpPlaying,mpPaused] then mp.Stop;
      mp.Close;
      lvPL.Items.Clear;
      LoadPlaylist(sl[n]);
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.mnuShowMenuClick(Sender: TObject);
begin
  mnuShowMenu.Checked := (not mnuShowMenu.Checked);
  mnuPopShowMenu.Checked := mnuShowMenu.Checked;
  SetVis;
end;

procedure TfrmMain.mnuMenuBarPlaylistClick(Sender: TObject);
begin
  pnlQueue.Visible := (not pnlQueue.Visible);
  mnuMenubarPlaylist.Checked := pnlQueue.Visible;
  mnuPopMenubarPlaylist.Checked := pnlQueue.Visible;
end;

procedure TfrmMain.mnuMenuBarTagsClick(Sender: TObject);
begin
  pnlTagCmd.Visible := (not pnlTagCmd.Visible);
  mnuMenubarTags.Checked := pnlTagCmd.Visible;
  mnuPopMenubarTags.Checked := pnlTagCmd.Visible;
end;

procedure TfrmMain.mnuMenuBarCoverArtClick(Sender: TObject);
begin
  pnlImgCmd.Visible := (not pnlImgCmd.Visible);
  mnuMenubarCoverArt.Checked := pnlImgCmd.Visible;
  mnuPopMenubarCoverArt.Checked := pnlImgCmd.Visible;
end;

procedure TfrmMain.mnuMenuBarSlideshowClick(Sender: TObject);
begin
  pnlSSCmd.Visible := (not pnlSSCmd.Visible);
  mnuMenubarSlideshow.Checked := pnlSSCmd.Visible;
  mnuPopMenubarSlideshow.Checked := pnlSSCmd.Visible;
end;

procedure TfrmMain.mnuMenuBarSoundbitesClick(Sender: TObject);
begin
  pnlSBCmd.Visible := (not pnlSBCmd.Visible);
  mnuMenubarSoundbites.Checked := pnlSBCmd.Visible;
  mnuPopMenubarSoundbites.Checked := pnlSBCmd.Visible;
end;

procedure TfrmMain.mnuMenuBarTextReaderClick(Sender: TObject);
begin
  pnlTRCmd.Visible := (not pnlTRCmd.Visible);
  mnuMenubarTextReader.Checked := pnlTRCmd.Visible;
  mnuPopMenubarTextReader.Checked := pnlTRCmd.Visible;
end;

procedure TfrmMain.mnuShuffleSSClick(Sender: TObject);
begin
  if bSetting then exit;
  mnuShuffleSS.Checked := (not mnuShuffleSS.Checked);
  bSetting := true;
  chkShuffleSS.Checked := mnuShuffleSS.Checked;
  bSetting := false;
  mnuPopShuffleSS.Checked := mnuShuffleSS.Checked;
end;

procedure TfrmMain.mnuGetCoverArtClick(Sender: TObject);

var m,a : string;

begin
  m := GetDirectory('Select MUSIC base folder (or Esc)');
  a := GetDirectory('Select AUDIOBOOK base folder (or Esc)');
  if m + a = '' then exit;
  DeleteFile(HDir + 'FIC.prm');
  AddFileText(HDir + 'FIC.prm',m);
  AddFileText(HDir + 'FIC.prm',a);
  ShellExecute(0,'open',pchar(HDir + 'FIC.exe'),nil,nil,SW_SHOWNORMAL);
  sb.Panels[2].Text := 'Launched: FIC.CoverArt()';
end;

procedure TfrmMain.mnuViewCoverArtClick(Sender: TObject);
begin
  pag.ActivePage := tabImages;
  SetVis;
end;

procedure TfrmMain.SetFloat;
begin
  if ViewMode <> vmFloating then exit;
  Width := img.Picture.Width;

  if Width < 64 then
    Width := Screen.Width div 3;

  Left := Screen.Width - Width;
  Height := img.Picture.Height;

  if Height < 64 then
    Height := Screen.Height div 3;
end;

procedure TfrmMain.mnuViewMinimalClick(Sender: TObject);
begin
  if ViewMode = vmMinimal then
  begin
    mnuViewNormalClick(Self);
    exit;
  end;

  mnuViewNormalClick(Self);
  ViewMode := vmMinimal;
  Menu := nil;
  sb.Visible := false;
  BorderStyle := bsSizeable;

  if (Height > Screen.Height div 3) or
   (Width > Screen.Width div 3) then
  begin
    Top := 0;
    Left := 0;
    Width := Screen.Width div 2;
    Height := pnlTop.Top + pnlTop.Height;
    pnlLeft.Width := Width - 120;
  end;
end;

procedure TfrmMain.mnuViewNormalClick(Sender: TObject);
begin
  pnlLeft.Visible := true;
  pnlTop.Visible := true;
  sb.Visible := true;
  spl.Visible := true;
  spl.Align := alRight; {helps}
  spl.Align := alLeft;  {helps}
  BorderStyle := bsSizeable;
  WindowState := wsNormal;
  img.ShowHint := false;
  ViewMode := vmNormal;
  SetVis;
end;

procedure TfrmMain.mnuViewNormal2Click(Sender: TObject);
begin
  mnuViewNormalClick(Self);
  Top := 20;
  Left := 30;
  Width := Screen.Width div 2;
  Height := Screen.Height div 2;
  pnlLeft.Width := Width;
  mnuFindCurrentClick(Self);
end;

procedure TfrmMain.mnuViewFloatingArtClick(Sender: TObject);
begin
  if ViewMode = vmFloating then
  begin
    mnuViewNormal2Click(Self);
    exit;
  end;

  Top := 0;
  Menu := nil;
  pnlTop.Visible := false;
  pnlLeft.Visible := false;
  sb.Visible := false;
  spl.Visible := false;
  BorderStyle := bsNone;
  WindowState := wsNormal;
  img.ShowHint := true;
  ViewMode := vmFloating;
  SetFloat;
end;

procedure TfrmMain.mnuViewFullArtClick(Sender: TObject);
begin
  if ViewMode = vmFullArt then
  begin
    mnuViewNormalClick(Self);
    exit;
  end;

  Menu := nil;
  pnlTop.Visible := false;
  pnlLeft.Visible := false;
  sb.Visible := false;
  spl.Visible := false;
  BorderStyle := bsNone;
  WindowState := wsMaximized;
  img.ShowHint := true;
  ViewMode := vmFullArt;
end;

procedure TfrmMain.cmdRenCancelClick(Sender: TObject);
begin
  cmdRenameClick(Self);
end;

procedure TfrmMain.cmdRenameClick(Sender: TObject);
begin
  pnlRename.Visible := (not pnlRename.Visible);

  if pnlRename.Visible then
  begin
    pnlRename.Align := alClient;

    try
      if cmbRenMask.Items.Count = 0 then
      begin
        if not FileExists(HDir + 'FAR.msk') then
        begin
          cmbRenMask.Items.Add('Artist\Album\Track Title');
          cmbRenMask.Items.Add('Artist-Album-Track-Title');
          cmbRenMask.Items.Add('Artist\Album-Track-Title');
          cmbRenMask.Items.Add('Artist\Album (Year)\Track-Title');
          cmbRenMask.Items.Add('Genre\Artist\Album\Track-Title');
          cmbRenMask.Items.SaveToFile(HDir + 'FAR.msk');
        end
        else cmbRenMask.Items.LoadFromFile(HDir + 'FAR.msk');

        cmbRenMask.Text := cmbRenMask.Items[0];
      end;
    except
    end;

    if cmdRenBaseDir.Hint = '' then
      cmdRenBaseDir.Hint := '..\';

    cmdRenRefreshClick(Self);
  end
  else
  begin
    pnlRename.Align := alNone;
    edtArtist.SetFocus;
  end;
end;

procedure TfrmMain.cmbRenMaskSelect(Sender: TObject);
begin
  cmdRenRefreshClick(Self);
end;

procedure TfrmMain.lvRenColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = sr.RenSortCol then
    sr.RenAsc := not sr.RenAsc
  else
    sr.RenSortCol := Column.Index;

  TListView(Sender).CustomSort(@SortByColumn,Column.Index);
end;

procedure TfrmMain.lvRenDblClick(Sender: TObject);

var i : TListItem;

begin
  if lvRen.Selected = nil then exit;
  cmdRenameClick(Self);
  pag.ActivePage := tabPlaylist;
  SetVis;
  i := lvPL.FindCaption(0,lvRen.Selected.Caption,false,true,false);

  if i <> nil then
  begin
    lvPL.Selected := i;
    i.MakeVisible(false);
  end;
end;

procedure TfrmMain.lvSBColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = sr.SBSortCol then
    sr.SBAsc := not sr.SBAsc
  else
    sr.SBSortCol := Column.Index;

  TListView(Sender).CustomSort(@SortByColumn,Column.Index);
end;

procedure TfrmMain.lvSSColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = sr.SSSortCol then
    sr.SSAsc := not sr.SSAsc
  else
    sr.SSSortCol := Column.Index;

  TListView(Sender).CustomSort(@SortByColumn,Column.Index);
end;

procedure TfrmMain.lvSSSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if (not bSetting) and
   (Selected) then
  begin
    pnlCap.Caption := Item.SubItems[siCaption];
    SetPic(Item.Caption);
  end;
end;

procedure TfrmMain.lvTRColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = sr.TRSortCol then
    sr.TRAsc := not sr.TRAsc
  else
    sr.TRSortCol := Column.Index;

  TListView(Sender).CustomSort(@SortByColumn,Column.Index);
end;

procedure TfrmMain.cmdRenRefreshClick(Sender: TObject);

var n : integer;
    i : TListItem;

begin
  lvRen.Items.Clear;

  for n := 0 to lvPL.Items.Count - 1 do
  begin
    if lvPL.Items[n].Selected then
    begin
      i := lvRen.Items.Add;
      i.Caption := lvPL.Items[n].Caption;
      i.SubItems.Add(TagBasedFilename(lvPL.Items[n]));
    end;
  end;

  if cmbRenMask.Items.IndexOf(cmbRenMask.Text) = -1 then
  begin
    cmbRenMask.Items.Insert(0,cmbRenMask.Text);
    cmbRenMask.Items.SaveToFile(HDir + 'FAR.msk');
  end;

  cmbRenMask.SetFocus;
end;

procedure TfrmMain.cmdRenBaseDirClick(Sender: TObject);

var s : string;

begin
  s := GetDirectory('Base Folder');
  if s = '' then exit;
  cmdRenBaseDir.Hint := s;
  cmdRenRefreshClick(Self);
end;

function TfrmMain.TagBasedFilename(i : TListItem) : string;

var msk,ext : string;

begin
  msk := trim(cmbRenMask.Text);
  ext := lowercase(copy(i.Caption,Length(i.Caption) - 3,4));

  msk := StringReplace(msk,'Artist',
   SafeName(trim(i.SubItems[siArtist])),[rfReplaceAll,rfIgnoreCase]);

  msk := StringReplace(msk,'Album',
   SafeName(trim(i.SubItems[siAlbum])),[rfReplaceAll,rfIgnoreCase]);

  msk := StringReplace(msk,'Track',
   ZeroPad(i.SubItems[siTrack],Length(IntToStr(lvRen.Items.Count))),[rfReplaceAll,rfIgnoreCase]);

  msk := StringReplace(msk,'Title',
   SafeName(trim(i.SubItems[siTitle])),[rfReplaceAll,rfIgnoreCase]);

  msk := StringReplace(msk,'Year',
   SafeName(trim(i.SubItems[siYear])),[rfReplaceAll,rfIgnoreCase]);

  msk := StringReplace(msk,'Genre',
   SafeName(trim(i.SubItems[siGenre])),[rfReplaceAll,rfIgnoreCase]);

  msk := StringReplace(msk,'Comment',
   SafeName(trim(i.SubItems[siComment])),[rfReplaceAll,rfIgnoreCase]);

  Result := FinalBS(cmdRenBaseDir.Hint) + msk + ext;
end;

procedure TfrmMain.cmdRenameExecClick(Sender: TObject);

var n,nIdx,j : integer;
    sl : TFileStrings;

begin
  if cmdRenBaseDir.Hint = '..\' then
  begin
    cmdRenBaseDir.SetFocus;
    ShowMessage('Select a base folder first.');
    exit;
  end;

  cmdStopClick(Self);
  tmrTrack.Enabled := false;

  for n := 0 to lvRen.Items.Count - 1 do
  begin
    sb.Panels[2].Text := 'Moving: ' + ExtractFilename(lvRen.Items[n].Caption);
    sb.Update;
    Application.ProcessMessages;
    MkDirs(ExtractFilePath(lvRen.Items[n].SubItems[0]));
    MoveFile(pchar(lvRen.Items[n].Caption),pchar(lvRen.Items[n].SubItems[0]));
    nIdx := GetTrackIdx(lvRen.Items[n].Caption);
    lvPL.Items[nIdx].Caption := lvRen.Items[n].SubItems[0];

    sl := TFileStrings.Create(ExtractFilePath(
     lvRen.Items[n].Caption),'*.jpg',true,false);

    try
      for j := 0 to sl.Count - 1 do
      begin
        MoveFile(pchar(sl[j]),pchar(
         ExtractFilePath(lvRen.Items[n].SubItems[0]) +
         ExtractFilename(sl[j])));

        sb.Panels[2].Text := 'Moving: ' + ExtractFilename(sl[j]);
        sb.Update;
        Application.ProcessMessages;
      end;
    except
    end;

    DelEmpty(ExtractFilePath(lvRen.Items[n].Caption));
    sl.Free;
  end;

  cmdRenameClick(Self);
  pag.ActivePage := tabPlaylist;
  SetVis;
  sb.Panels[2].Text := 'Finished: tag-based renaming.';
end;

procedure TfrmMain.PasteToAll(Fld : byte);

var s,t : string;
    n : integer;

begin
  case Fld of
    siArtist : t := 'Artist';
    siAlbum : t := 'Album';
    siTitle : t := 'Title';
    siYear : t := 'Year';
    siGenre : t := 'Genre';
    siComment : t := 'Comment';
    else exit;
  end;

  s := trim(Clipboard.AsText);

  if not Confirm('FAR',s + #13#13 +
   'Replace all selected ' + t + ' tags?') then exit;

  tmrTrack.Enabled := false;
  Usurp(true);

  try
    for n := 0 to lvPL.Items.Count - 1 do
    begin
      if lvPL.Items[n].Selected then
      begin
        Tags.LoadFromFile(lvPL.Items[n].Caption);

        case Fld of
          siArtist:
            begin
              Tags.Artist := s;
              lvPL.Items[n].SubItems[siArtist] := s;
            end;
          siAlbum:
            begin
              Tags.Album := s;
              lvPL.Items[n].SubItems[siAlbum] := s;
            end;
          siTitle:
            begin
              Tags.Title := s;
              lvPL.Items[n].SubItems[siTitle] := s;
            end;
          siYear:
            begin
              Tags.Year := s;
              lvPL.Items[n].SubItems[siYear] := s;
            end;
          siGenre:
            begin
              Tags.Genre := s;
              lvPL.Items[n].SubItems[siGenre] := s;
            end;
          siComment:
            begin
              Tags.Comment := s;
              lvPL.Items[n].SubItems[siComment] := s;
            end;
        end;

        Tags.SaveToFile(lvPL.Items[n].Caption);
      end;
    end;
  finally
    tmrTrack.Enabled := (pag.ActivePage <> tabTags);
    Usurp(false);
  end;
end;

procedure TfrmMain.mnuPopulateDurationsClick(Sender: TObject);

var slFiles : TFileStrings;
    n,pct,ups : integer;
    s : string;
    Len : cardinal;
    bZap : boolean;

begin
  if not Confirm('FAR',
   'Stop player and add durations to Comment tags?') then
    exit;

  ups := 0;
  Top := 0;
  Left := 0;
  Height := 10;
  Width := Screen.Width div 2;
  bZap := Confirm('FAR','Overwrite existing Comment values instead of appending?');
  s := GetDirectory('Base folder');
  if s = '' then exit;
  cmdStopClick(Self);
  Enabled := false;
  sb.Panels[0].Text := 'Build';
  sb.Panels[1].Text := ' - - ';
  sb.Panels[2].Text := '';
  Caption := 'FAR - Scanning files...';
  sb.Update;
  slFiles := TFileStrings.Create(s,'*.*',true,true);

  try
    for n := 0 to slFiles.Count - 1 do
    begin
      Len := 0;
      pct := Round(((n + 1) / slFiles.Count) * 100);

      try
        if InStrSet(lowercase(copy(slFiles[n],Length(
         slFiles[n]) - 3,4)),'.mp3,.wma,.wav,.mid') then
        begin
          mp.FileName := slFiles[n];
          mp.Open;
          Len := mp.Length;
          mp.Close;
        end;
      except
      end;

      Tags.LoadFromFile(slFiles[n]);
      s := PrettyMS(Len);

      if pos(s,Tags.Comment) = 0 then
      begin
        if not bZap then
        begin
          if trim(Tags.Comment) = '' then
            Tags.Comment := s
          else
            Tags.Comment := trim(Tags.Comment) + ' (' + s + ')';
        end
        else Tags.Comment := s;

        Tags.SaveToFile(slFiles[n]);
        inc(ups);
      end;

      s := 'Checking tags (' +
       IntToStr(pct) + '% - updated ' + CommaStr(
       IntToStr(ups)) + ')...';

      Caption := 'FAR - ' + s;
      Update;
    end;
  except
  end;

  slFiles.Free;
  mp.FileName := '';
  sb.Panels[0].Text := 'Ready';
  sb.Panels[2].Text := 'Finished updating ' + CommaStr(IntToStr(ups)) + ' tags.';
  Caption := 'FAR';
  LoadWinPos(Self,UDir + 'FAR.ini');
  Enabled := true;
end;

procedure TfrmMain.mnuMakePortablePlaylistsClick(Sender: TObject);

var sl : TStringList;
    n,j : integer;
    dir : string;
    dp : boolean;

begin
  dlgOpen.FilterIndex := fsPlaylist;
  dlgOpen.InitialDir := UDir + 'Playlists';
  if not dlgOpen.Execute then exit;
  dir := FinalBS(GetDirectory('Output Folder'));
  if dir  = '\' then exit;
  dp := Confirm('FAR','Remove path references in addition to drive?');
  sl := TStringList.Create;

  try
    for n := 0 to dlgOpen.Files.Count - 1 do
    begin
      sl.LoadFromFile(dlgOpen.Files[n]);

      for j := 0 to sl.Count - 1 do
      begin
        if pos(':',sl[j]) > 0 then
        begin
          if dp then
            sl[j] := ExtractFilename(sl[j])
          else
            sl[j] := copy(sl[j],3,999);
        end
        else if copy(sl[j],1,2) = '\\' then
        begin
          if dp then
            sl[j] := ExtractFilename(sl[j])
          else
            sl[j] := StripVol(sl[j]);
        end
      end;

      sl.SaveToFile(dir + ExtractFilename(
       dlgOpen.Files[n]));

      sb.Panels[2].Text := 'Created ' + IntToStr(n) + ' of ' +
       IntToStr(dlgOpen.Files.Count) + ' playlists...';

      Application.ProcessMessages;
    end;
  finally
    sl.Free;
    sb.Panels[2].Text := 'Created ' + IntToStr(dlgOpen.Files.Count) + ' playlists in ' + dir;
  end;
end;

procedure TfrmMain.mnuSampleClick(Sender: TObject);

var n,j : integer;
    slFiles : TFileStrings;
    slFile : TStringList;

begin
  if SampleRec.Sampling then
  begin
    mnuSample.Checked := false;
    mnuPopSample.Checked := false;
    StopSample;
    sb.Panels[2].Text := 'Sampling stopped.';
    exit;
  end;

  mnuSample.Checked := true;
  mnuPopSample.Checked := true;
  SampleRec.PlaySecs := 0;
  SampleRec.Sampling := true;
  SampleRec.slPix.Clear;

  if (FilesExist(UDir + 'Slideshows\*.fss')) and
   (Confirm('FAR','Use random slides?')) then
  begin
    slFiles := TFileStrings.Create(UDir + 'Slideshows','*.fss',true,true);
    slFile := TStringList.Create;
    sb.Panels[0].Text := 'Busy';
    sb.Panels[1].Text := '- - -';
    sb.Panels[2].Text := 'Building picture pool...';
    sb.Update;

    try
      for n := 0 to slFiles.Count - 1 do
      begin
        slFile.LoadFromFile(slFiles[n]);

        for j := 0 to slFile.Count - 1 do
        begin
          if (SampleRec.slPix.IndexOf(slFile[j]) = -1) and
           (FileExists(slFile[j])) then
            SampleRec.slPix.Add(slFile[j]);
        end;
      end;
    except
    end;

    slFile.Free;
    slFiles.Free;
  end;

  cmdJukeboxClick(Self);
end;

procedure TfrmMain.Sample;
begin
  with SampleRec do
  begin
    if PlaySecs > 12 then
    begin
      if PLIdx >= lvPL.Items.Count - 1 then
      begin
        StopSample;
        if mnuRepeat.Checked then mnuSampleClick(Self);
        exit;
      end;

      PlaySecs := 0;
      NextTrack;
      cmdPlayPauseClick(Self);
      mp.Position := Random(mp.Length);

      if mp.Position > (mp.Length - 15000) then
        mp.Position := mp.Length - 15000;

      cmdPlayPauseClick(Self);

      if slPix.Count > 0 then
      begin
        SetPic(slPix[Random(slPix.Count)]);
        sb.Panels[2].Text := StripExt(ExtractFilename(ImgFile));
      end;
    end;

    inc(PlaySecs);
  end;

  if mp.Mode = mpPlaying then
    sb.Panels[1].Text := PrettyMS(mp.Position);
end;

procedure TfrmMain.StopSample;
begin
  cmdStopClick(Self);
end;

procedure TfrmMain.mnuPasteToAllAlbumClick(Sender: TObject);
begin
  PasteToAll(siAlbum);
end;

procedure TfrmMain.mnuPasteToAllArtistClick(Sender: TObject);
begin
  PasteToAll(siArtist);
end;

procedure TfrmMain.mnuPasteToAllCommentClick(Sender: TObject);
begin
  PasteToAll(siComment);
end;

procedure TfrmMain.mnuPasteToAllGenreClick(Sender: TObject);
begin
  PasteToAll(siGenre);
end;

procedure TfrmMain.mnuPasteToAllTitleClick(Sender: TObject);
begin
  PasteToAll(siTitle);
end;

procedure TfrmMain.mnuPasteToAllYearClick(Sender: TObject);
begin
  PasteToAll(siYear);
end;

procedure TfrmMain.cmdNewSSClick(Sender: TObject);

var Dir : string;
    sl : TFileStrings;
    fss : string;
    n : integer;

begin
  mnuViewSlideShowsClick(Self);
  Dir := GetDirectory('Images Base Folder');
  if Dir = '' then exit;
  fss := '';
  lvSS.Items.Clear;
  Enabled := false;
  sl := nil;

  try
    sb.Panels[0].Text := 'Build';
    sb.Panels[1].Text := ' - - ';
    sb.Panels[2].Text := 'Scanning files...';
    sb.Update;
    sl := TFileStrings.Create(Dir,'*.jpg',true,true);

    if sl.Count > 0 then
    begin
      fss := copy(Dir,4,999);
      fss := StringReplace(fss,'\','-',[rfReplaceAll]);
      fss := UDir + 'SlideShows\' + fss + '.fss';
      SaveSS(sl,fss);
      fss := FinalBS(Dir) + ExtractFilename(fss);

      if pos(':',sl[0]) > 0 then
      begin
        for n := 0 to sl.Count - 1 do
          sl[n] := copy(sl[n],Length(Dir) + 2,999);
      end
      else
      begin
        for n := 0 to sl.Count - 1 do
          sl[n] := copy(sl[n],Length(Dir) + 1,999);
      end;

      SaveSS(sl,fss);
    end
    else sb.Panels[2].Text := 'No jpg images found.';
  except on e : exception do
    ShowMessage(e.Message);
  end;

  Enabled := true;
  if sl <> nil then sl.Free;
  sb.Panels[0].Text := 'Ready';
  if fss <> '' then LoadSS(fss,1);
end;

procedure TfrmMain.LoadSS(sFile : string; StartPos : integer);

var sl : TStringList;
    n : integer;
    sCap,sDelay,sRep,sSync,sOther,sFont : string;

procedure AddSS(sImg : string);

var i : TListItem;

begin
  i := lvSS.Items.Add;
  i.Caption := sImg;
  i.SubItems.Add(StripExt(ExtractFilename(sImg)));
  i.SubItems.Add(sDelay);
  i.SubItems.Add(sSync);
  i.SubItems.Add(sRep);
  i.SubItems.Add(sOther);
  i.SubItems.Add(sFont);
end;

begin // LoadSS
  if not FileExists(sFile) then
  begin
    sb.Panels[2].Text := 'File not found: ' + sFile;
    exit;
  end;

  pag.ActivePage := tabSlideShow;
  SetVis;
  lvSS.Clear;
  ss.Filename := sFile;
  n := 0;
  sl := TStringList.Create;
  lvSS.Items.BeginUpdate;

  try
    sl.LoadFromFile(sFile);

    while n < sl.Count - 1 do
    begin
      sCap := sl[n + 1];
      sDelay := sl[n + 2];
      sSync := sl[n + 3];
      if not FileExists(sSync) then sSync := ExtractFilePath(sFile) + sSync;
      sRep := sl[n + 4];
      sOther := sl[n + 5];
      if (sOther <> '') and (not FileExists(sOther)) then sOther := ExtractFilePath(sFile) + sOther;
      sFont := sl[n + 6];

      if FileExists(sl[n]) then
        AddSS(sl[n])
      else if FileExists(ExtractFilePath(sFile) + sl[n]) then
        AddSS(ExtractFilePath(sFile) + sl[n]);

      inc(n,7);
    end;
  except on e : exception do
    ShowMessage(sFile + #13#13 + 'Error loading file.');
  end;

  lvSS.Items.EndUpdate;
  sl.Free;
  StartSS(StartPos);
end;

procedure TfrmMain.StartSS(Slide : integer);
begin
  if lvSS.Items.Count = 0 then exit;
  mnuCoverArtSlideshow.Checked := false;
  mnuPopCoverArtSlideshow.Checked := false;

  if (chkShuffleSS.Checked) and (lvSS.Items.Count > 1) then
    ShuffleLV(lvSS);

  ss.Active := true;
  pnlCap.Visible := true;
  SetPlayCap(csSS,false);
  ss.Idx := Slide - 2;
  sb.Panels[2].Text := StripExt(ExtractFilename(ss.Filename));

  if ss.SetOrig then
  begin
    ss.usurped.Filename := mp.FileName;
    ss.usurped.Position := mp.Position;
    ss.usurped.Mode := mp.Mode;
  end
  else ss.SetOrig := true;

  NextSS;
end;

procedure TfrmMain.lvSSDblClick(Sender: TObject);
begin
  if lvSS.ItemIndex = -1 then exit;
  if mnuShuffleSS.Checked then mnuShuffleSSClick(Self);
  StartSS(lvSS.ItemIndex + 1);
end;

procedure TfrmMain.NextSS;
begin
  if lvSS.Items.Count = 0 then exit;
  ss.Wait := 0;
  ss.RepCount := 1;
  inc(ss.Idx);

  if ss.Idx >= lvSS.Items.Count then
  begin
    if not chkRepeatSS.Checked then
    begin
      cmdStopSSClick(Self);
      exit;
    end
    else
    begin
      ss.SetOrig := false;
      StartSS(1);
      exit;
    end;
  end;

  lvSS.ClearSelection;
  lvSS.ItemIndex := ss.Idx;
  if lvSS.Visible then lvSS.Items[ss.Idx].MakeVisible(false);
  ss.Delay := StrToInt2(lvSS.Items[ss.Idx].SubItems[siDelay]);
  ss.Rep := StrToInt2(lvSS.Items[ss.Idx].SubItems[siRepeat]);
  ss.Sync := lvSS.Items[ss.Idx].SubItems[siSync];
  ss.Other := lvSS.Items[ss.Idx].SubItems[siOther];
  pnlCap.Font.Name := lvSS.Items[ss.Idx].SubItems[siFont];
  if pnlCap.Font.Name = '' then pnlCap.Font.Name := c_Font;
  pnlCap.Caption := lvSS.Items[ss.Idx].SubItems[siCaption];
  ss.ImgFile := lvSS.Items[ss.Idx].Caption;
  if FileExists(ss.Sync) then PlayFile(ss.Sync,0);
  if FileExists(ss.Other) then RunAssoc(ss.Other);
  SetPic(ss.ImgFile);
  tmrTrack.Enabled := true;
end;

procedure TfrmMain.cmdStopSSClick(Sender: TObject);
begin
  if not ss.Active then exit;
  ss.Active := false;
  ss.SetOrig := true;
  pnlCap.Visible := false;
  SetPlayCap(csSS,true);
  sb.Panels[0].Text := 'Stopped';
  sb.Panels[1].Text := '- - -';
  sb.Panels[2].Text := '';

  if (mp.Mode in [mpPlaying,mpPaused]) and
   (ss.Sync = mp.FileName) then
    cmdStopClick(Self);
end;

procedure TfrmMain.cmdRemoveSSClick(Sender: TObject);
begin
  if pag.ActivePage <> tabSlideShow then exit;
  if lvSS.ItemIndex = -1 then exit;
  if lvSS.Selected = nil then exit;
  lvSS.DeleteSelected;
  SaveSS(nil,ss.Filename);
end;

procedure TfrmMain.cmdOpenSSClick(Sender: TObject);
begin
  dlgOpen.InitialDir := UDir + 'SlideShows';
  dlgOpen.FilterIndex := fsSlideShow;
  if not dlgOpen.Execute then exit;
  mnuViewSlideShowsClick(Self);
  LoadSS(dlgOpen.Filename,1);
end;

procedure TfrmMain.SaveSS(sl : TStrings; sFile : string);

var n : integer;
    i : TListItem;
    slFile : TStringList;

begin
  slFile := TStringList.Create;

  try
    if sl = nil then
    begin
      for n := 0 to lvSS.Items.Count - 1 do
      begin
        i := lvSS.Items[n];
        slFile.Add(i.Caption);
        slFile.Add(i.SubItems[siCaption]);
        slFile.Add(i.SubItems[siDelay]);
        slFile.Add(i.SubItems[siSync]);
        slFile.Add(i.SubItems[siRepeat]);
        slFile.Add(i.SubItems[siOther]);
        slFile.Add(i.SubItems[siFont]);
      end;
    end
    else
    begin
      for n := 0 to sl.Count - 1 do
      begin
        slFile.Add(sl[n]);
        slFile.Add(StripExt(ExtractFilename(sl[n])));
        slFile.Add('12');
        slFile.Add('');
        slFile.Add('0');
        slFile.Add('');
        slFile.Add('');
      end;
    end;

    slFile.SaveToFile(sFile);
    sb.Panels[2].Text := 'Saved: ' + ExtractFilename(sFile);
  except
  end;

  slFile.Free;
end;

procedure TfrmMain.cmdAddSlideShowClick(Sender: TObject);

var Dir : string;
    sl : TFileStrings;
    n : integer;
    i : TListItem;

begin
  if ss.Filename = '' then
  begin
    cmdNewSSClick(Self);
    exit;
  end;

  Dir := GetDirectory('Images Base Folder');
  if Dir = '' then exit else Dir := FinalBS(Dir);
  Enabled := false;
  sl := TFileStrings.Create(Dir,'*.jpg',true,true);
  lvSS.Items.BeginUpdate;

  try
    for n := 0 to sl.Count - 1 do
    begin
      i := lvSS.Items.Add;
      i.Caption := sl[n];
      i.SubItems.Add(StripExt(ExtractFilename(sl[n])));
      i.SubItems.Add('12');
      i.SubItems.Add('');
      i.SubItems.Add('0');
      i.SubItems.Add('');
      i.SubItems.Add('');
    end;

    SaveSS(nil,ss.Filename);
  except on e : exception do
    ShowMessage(e.Message);
  end;

  lvSS.Items.EndUpdate;
  Enabled := true;
  sl.Free;
end;

procedure TfrmMain.cmdEditSBClick(Sender: TObject);
begin
  if lvSB.Selected = nil then exit;

  with frmSB do
  begin
    edtAudio.Text := lvSB.Items[lvSB.ItemIndex].SubItems[0];
    edtStart.Text := lvSB.Items[lvSB.ItemIndex].SubItems[1];
    edtDur.Text := lvSB.Items[lvSB.ItemIndex].SubItems[2];
    ShowModal;
    if RetVal = rvCancel then exit;
    lvSB.DeleteSelected;
    SaveSB(edtAudio.Text,edtStart.Text,edtDur.Text);
  end;
end;

procedure TfrmMain.cmdEditSSClick(Sender: TObject);

var i : TListItem;

begin
  if lvSS.ItemIndex = -1 then exit;

  with frmEditSS do
  begin
    i := lvSS.Items[lvSS.ItemIndex];
    edtImg.Text := i.Caption;
    edtCaption.Text := i.SubItems[siCaption];
    edtDelay.Text := i.SubItems[siDelay];
    edtRepeat.Text := i.SubItems[siRepeat];
    edtSync.Text := i.SubItems[siSync];
    edtOther.Text := i.SubItems[siOther];
    FontName := i.SubItems[siFont];
    ShowModal;
    if RetVal = rvCancel then exit;
    i.Caption := edtImg.Text;
    i.SubItems[siCaption] := edtCaption.Text;
    i.SubItems[siDelay] := edtDelay.Text;
    i.SubItems[siRepeat] := edtRepeat.Text;
    i.SubItems[siSync] := edtSync.Text;
    i.SubItems[siOther] := edtOther.Text;
    i.SubItems[siFont] := FontName;
    SaveSS(nil,ss.Filename);
  end;
end;

procedure TfrmMain.cmdFontTRClick(Sender: TObject);
begin
  dlgFont.Font := redTR.Font;
  if not dlgFont.Execute then exit;
  redTR.Font := dlgFont.Font;
end;

procedure TfrmMain.cmdMoveUpSSClick(Sender: TObject);
begin
  if pag.ActivePage <> tabSlideShow then exit;
  if lvSS.ItemIndex < 1 then exit;
  ExchangeItems(lvSS,lvSS.ItemIndex - 1);
  if ss.Idx = (lvSS.ItemIndex + 1) then dec(ss.Idx);
  if (lvSS.Visible) and (pag.ActivePage = tabSlideshow) then lvSS.SetFocus;
end;

procedure TfrmMain.cmdMoveDownSSClick(Sender: TObject);
begin
  if pag.ActivePage <> tabSlideShow then exit;
  if lvSS.ItemIndex = -1 then exit;
  if lvSS.ItemIndex = lvSS.Items.Count - 1 then exit;
  ExchangeItems(lvSS,lvSS.ItemIndex + 1);
  if ss.Idx = (lvSS.ItemIndex - 1) then inc(ss.Idx);
  if (lvSS.Visible) and (pag.ActivePage = tabSlideshow) then lvSS.SetFocus;
end;

function TfrmMain.AudioLen(sFile : string) : dword;
begin
  Usurp(true);
  mp.FileName := sFile;
  mp.Open;
  Result := mp.Length;
  Usurp(false);
end;

procedure TfrmMain.cmdLinkSSClick(Sender: TObject);

var n,j,y : integer;
    b : boolean;

begin
  if lvPL.Items.Count = 0 then
  begin
    pag.ActivePage := tabPlaylist;
    SetVis;
    ShowMessage('The playlist queue is empty.');
    exit;
  end;

  if lvSS.Items.Count = 0 then
  begin
    pag.ActivePage := tabSlideShow;
    SetVis;
    ShowMessage('The slideshow queue is empty.');
    exit;
  end;

  if not Confirm('FAR',
   'Set SyncAudio fields to current playlist queue, starting from selected playlist entry and slide?') then
    exit;

  b := Confirm('FAR','Set Delay = AudioLen?');
  j := lvPL.ItemIndex - 1;
  if j < -1 then j := -1;
  if lvSS.ItemIndex = -1 then lvSS.ItemIndex := 0;
  y := lvSS.ItemIndex;

  for n := y to lvSS.Items.Count - 1 do
  begin
    inc(j);
    if j >= lvPL.Items.Count then break;
    lvSS.Items[n].SubItems[siSync] := lvPL.Items[j].Caption;

    if b then
      lvSS.Items[n].SubItems[siDelay] := IntToStr(
       AudioLen(lvSS.Items[n].SubItems[siSync]) div 1000);
  end;

  SaveSS(nil,ss.Filename);
  sb.Panels[2].Text := 'Finished linking entries.';
end;

procedure TfrmMain.cmdNewSBClick(Sender: TObject);
begin
  with frmSB do
  begin
    edtAudio.Text := '';
    edtStart.Value := 0;
    edtDur.Value := 0;
    ShowModal;
    if RetVal = rvCancel then exit;
    SaveSB(edtAudio.Text,edtStart.Text,edtDur.Text);
  end;
end;

procedure TfrmMain.SaveSB(Audio,Start,Dur : string);

var fsb : string;

begin
  fsb := UDir + 'SoundBites\' + StripExt(ExtractFilename(
   Audio)) + '_' + Start + '_' + Dur + '.fsb';

  DeleteFile(fsb);
  AddFileText(fsb,PadR(Start,10) + PadR(Dur,10) + Audio);
  AddSB(fsb,Audio,Start,Dur);
end;

procedure TfrmMain.AddSB(sFile,Audio,Start,Dur : string);

var i : TListItem;

begin
  i := lvSB.Items.Add;
  i.Caption := sFile;
  i.SubItems.Add(Audio);
  i.SubItems.Add(Start);
  i.SubItems.Add(Dur);
end;

procedure TfrmMain.cmdDeleteSBClick(Sender: TObject);

var n : integer;

begin
  if lvSB.SelCount = 0 then exit;

  if not Confirm('FAR','Delete ' + IntToStr(lvSB.SelCount) +
   ' files?') then exit;

  for n := 0 to lvSB.Items.Count - 1 do
  begin
    if lvSB.Items[n].Selected then
      DeleteFile(lvSB.Items[n].Caption);
  end;

  lvSB.DeleteSelected;
end;

procedure TfrmMain.ListSoundBites;

var sl : TFileStrings;
    n : integer;
    Txt,Audio,Start,Dur : string;

begin
  sl := TFileStrings.Create(UDir + 'SoundBites','*.fsb',true,false);

  for n := 0 to sl.Count - 1 do
  begin
    Txt := FileStr(sl[n]);
    Audio := copy(Txt,21,999);
    Start := trim(copy(Txt,1,10));
    Dur := trim(copy(Txt,11,10));
    AddSB(sl[n],Audio,Start,Dur);
  end;
end;

procedure TfrmMain.PlaySB(sFile : string);

var i : TListItem;

begin
  i := lvSB.FindCaption(0,sFile,false,true,false);
  if i = nil then exit;
  lvPL.Selected := lvPL.FindCaption(0,sFile,false,true,false);

  if (pag.ActivePage = tabPlaylist) and
   (lvPL.Selected <> nil) and
   (lvPL.Visible) then
  begin
    lvPL.Selected.MakeVisible(false);
    lvPL.SetFocus;
  end;

  sbite.Wait := 0;
  sbite.Delay := StrToInt2(i.SubItems[2]);
  Usurp(true);
  mp.Filename := i.SubItems[0];
  sb.Panels[0].Text := 'Playing';
  sb.Panels[2].Text := StripExt(ExtractFilename(mp.Filename));
  mp.Open;
  mp.Position := StrToInt2(i.SubItems[1]) * 1000;
  tbPosition.Max := mp.Length;
  tbPosition.Position := mp.Position;
  tmrTrack.Enabled := false;
  mp.Play;
  tmrUsurp.Enabled := true;
end;

procedure TfrmMain.pnlCapClick(Sender: TObject);

var s,sOld : string;

begin
  if lvSS.ItemIndex = -1 then exit;
  ss.Idx := lvSS.ItemIndex;
  if cmdPlaySS.Caption = 'Pause' then cmdPlaySSClick(Self);
  pnlSSCtrls.Visible := false;
  pnlCap.Caption := lvSS.Items[ss.Idx].Caption;
  s := StripExt(ExtractFilename(lvSS.Items[ss.Idx].Caption));
  sOld := s;
  InputQuery('FAR','New Name',s);
  pnlSSCtrls.Visible := true;
  pnlCap.Caption := sOld;
  if (s = '') or (s = sOld) then exit;
  s := ExtractFilePath(lvSS.Items[ss.Idx].Caption) + s;
  s := s + ExtractFileExt(lvSS.Items[ss.Idx].Caption);
  RenameFile(lvSS.Items[ss.Idx].Caption,s);
  lvSS.Items[ss.Idx].Caption := s;
  lvSS.ClearSelection;
  lvSS.ItemIndex := ss.Idx;

  if (lvSS.Items[ss.Idx].SubItems[siCaption] = '') or
   (lvSS.Items[ss.Idx].SubItems[siCaption] = sOld) then
  begin
    lvSS.Items[ss.Idx].SubItems[siCaption] := StripExt(
     ExtractFilename(s));

    cmdEditSSClick(Self);

    if frmEditSS.RetVal = rvCancel then
      lvSS.Items[ss.Idx].SubItems[siCaption] := sOld;
  end;

  pnlCap.Caption := lvSS.Items[ss.Idx].Caption;
end;

procedure TfrmMain.tmrUsurpTimer(Sender: TObject);
begin
  inc(sbite.Wait);

  if not ss.Active then
  begin
    bSetting := true;
    tbPosition.Position := mp.Position;
    bSetting := false;
  end;

  if sbite.Wait >= sbite.Delay then
  begin
    tmrUsurp.Enabled := false;
    try mp.Stop; except end;
    sb.Panels[2].Text := '';
    Usurp(false);
    tmrTrack.Enabled := true;
  end
  else sb.Panels[1].Text := PrettyMS(tbPosition.Position);
end;

procedure TfrmMain.DelFileFromDisk;

var n,nDel : integer;

begin
  if lvPL.ItemIndex = -1 then exit;
  nDel := 0;

  for n := 0 to lvPL.Items.Count - 1 do
    if lvPL.Items[n].Selected then
      inc(nDel);

  if not Confirm('FAR','Delete ' + IntToStr(nDel) +
   ' file(s) from disk?') then exit;

  for n := 0 to lvPL.Items.Count - 1 do
  begin
    if lvPL.Items[n].Selected then
    begin
      if mp.FileName = lvPL.Items[n].Caption then
      begin
        cmdStopClick(Self);
        Sleep(300);
      end;

      DeleteFile(lvPL.Items[n].Caption);
    end;
  end;

  lvPL.DeleteSelected;
  if FileExists(PLFile) then SavePlaylist;
end;

procedure TfrmMain.edtImgDirDblClick(Sender: TObject);
begin
  WinExec(edtImgDir.Text,'');
end;

procedure TfrmMain.cmdQueueSBClick(Sender: TObject);

var n : integer;

begin
  for n := 0 to lvSB.Items.Count - 1 do
  begin
    if lvSB.Items[n].Selected then
      AddTrack(lvPL,lvSB.Items[n].Caption);
  end;

  if (lvSB.SelCount > 0) and
   (mp.Mode <> mpPlaying) then
  begin
    pag.ActivePage := tabPlaylist;
    SetVis;
    StartPlaylist;
  end;
end;

procedure TfrmMain.cmdVoiceClick(Sender: TObject);
begin
  frmVoice.ShowModal;
  if frmVoice.RetVal = rvCancel then exit;
  spv.Rate := frmVoice.edtRate.Value;
  spv.Volume := frmVoice.edtVolume.Value;

  spv.Voice := ISpeechObjectToken(Pointer(frmVoice.
   cmbVoice.Items.Objects[frmVoice.cmbVoice.ItemIndex]));
end;

procedure TfrmMain.cmdPasteTRClick(Sender: TObject);
begin
  cmdStopTRClick(Self);
  redTR.Text := Clipboard.AsText;
  edtTRFile.Text := ExtractFilePath(edtTRFile.Text);

  if DirectoryExists(edtTRFile.Text) then
    edtTRFile.Text := edtTRFile.Text + 'Clipboard.txt'
  else
    edtTRFile.Text := HDir + 'Clipboard.txt';

  redTR.Lines.SaveToFile(edtTRFile.Text);
  StartTR(0);
end;

procedure TfrmMain.cmdOpenTRClick(Sender: TObject);
begin
  dlgOpen.FilterIndex := fsText;
  dlgOpen.InitialDir := ExtractFilePath(edtTRFile.Text);
  if not dlgOpen.Execute then exit;
  LoadTR(dlgOpen.Filename,0);
end;

procedure TfrmMain.LoadTR(sFile : string; ViewPos : integer);
begin
  pag.ActivePage := tabTextReader;
  edtTRFile.Text := sFile;
  redTR.Text := ''; {resets view}
  redTR.Lines.LoadFromFile(sFile);
  redTR.SelStart := ViewPos;
  //StartTR();
end;

procedure TfrmMain.StartTR(nSkips : integer);
begin
  pag.ActivePage := tabTextReader;
  SetVis;

  if trim(redTR.Text) = '' then
  begin
    ShowMessage('No text.');
    exit;
  end;

  if not FileExists(edtTRFile.Text) then
  begin
    ShowMessage('Textfile not found.');
    exit;
  end;

  sb.Panels[0].Text := 'Playing';
  sb.Panels[2].Text := StripExt(ExtractFilename(edtTRFile.Text));
  redTR.Lines.LoadFromFile(edtTRFile.Text);
  cmdPlayTR.Caption := 'Pause';
  mnuPlayTR.Caption := '&Pause';
  mnuPopPlayTR.Caption := '&Pause';
  spv.EventInterests := SVEAllEvents;
  tr.Skips := nSkips;
  tr.Mode := trPlay;
  spv.Speak(redTR.Text,SVSFlagsAsync or SVSFPurgeBeforeSpeak);
  if tr.Skips > 0 then spv.Skip('Sentence',tr.Skips);
end;

procedure TfrmMain.cmdPlayTRClick(Sender: TObject);
begin
  if cmdPlayTR.Caption = 'Play' then
  begin
    if FileExists(edtTRFile.Text) then
    begin
      if tr.Mode = trPause then
        spv.Resume
      else
        StartTR(0);
    end
    else cmdOpenTRClick(Self);
  end
  else
  begin
    spv.Pause;
    tr.Mode := trPause;
    cmdPlayTR.Caption := 'Play';
    mnuPlayTR.Caption := '&Play';
    mnuPopPlayTR.Caption := '&Play';
  end
end;

procedure TfrmMain.cmdStopTRClick(Sender: TObject);
begin
  tr.Mode := trStop;
  tr.Skips := 0;
  //spv.Skip('Sentence',MaxInt);
  spv.Speak('',SVSFPurgeBeforeSpeak);
  cmdPlayTR.Caption := 'Play';
  mnuPlayTR.Caption := '&Play';
  mnuPopPlayTR.Caption := '&Play';
end;

procedure TfrmMain.spvSentence(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant; CharacterPosition, Length: Integer);
begin
  tr.StreamNum := StreamNumber;
  tr.StreamPos := StreamPosition;
  tr.ChrPos := CharacterPosition;
  tr.Len := Length;
  sb.Panels[1].Text := IntToStr(tr.Skips);
end;

procedure TfrmMain.spvEndStream(ASender: TObject; StreamNumber: Integer; StreamPosition: OleVariant);
begin {
  if dword(StreamPosition) >= Length(redTR.Text) then
  begin
    tr.Mode := trStop;
    cmdPlayTR.Caption := 'Play';
    mnuPlayTR.Caption := 'Play';
    mnuPopPlayTR.Caption := 'Play';
    sb.Panels[0].Text := 'Stopped';
  end; }
end;

procedure TfrmMain.cmdPrevSlideClick(Sender: TObject);
begin
  if (ss.Active) and (ss.Idx > 0) then
  begin
    dec(ss.Idx,2);
    NextSS;
  end;
end;

procedure TfrmMain.cmdPrevSSIdxClick(Sender: TObject);
begin
  if ss.Active then
  begin
    dec(ss.Wait,15);
    if ss.Wait < 1 then cmdPrevSlideClick(Self);
  end;
end;

procedure TfrmMain.cmdNextSSIdxClick(Sender: TObject);
begin
  if (ss.Active) then inc(ss.Wait,15);
end;

procedure TfrmMain.cmdNextSlideClick(Sender: TObject);
begin
  if ss.Active then
  begin
    ss.Wait := ss.Delay;
    ss.RepCount := ss.Rep;
  end;
end;

procedure TfrmMain.SetPlayCap(CapSet : byte; bPlay : boolean);
begin
  if CapSet = csMP then
  begin
    if bPlay then
    begin
      cmdPlayPause.Caption := 'Play';
      mnuPlayPause.Caption := '&Play';
      mnuPopPlay.Caption := '&Play';
    end
    else
    begin
      cmdPlayPause.Caption := 'Pause';
      mnuPlayPause.Caption := '&Pause';
      mnuPopPlay.Caption := '&Pause';
    end;
  end
  else if CapSet = csSS then
  begin
    if bPlay then
    begin
      cmdPlaySS.Caption := 'Play';
      cmdPlaySS2.Caption := 'Play';
      mnuPlaySS.Caption := '&Play';
      mnuPopPlaySS.Caption := '&Play';
    end
    else
    begin
      cmdPlaySS.Caption := 'Pause';
      cmdPlaySS2.Caption := 'Pause';
      mnuPlaySS.Caption := '&Pause';
      mnuPopPlaySS.Caption := '&Pause';
    end;
  end;
end;

procedure TfrmMain.cmdPlayPauseClick(Sender: TObject);
begin
  if cmdPlayPause.Caption = 'Play' then
  begin
    if mp.FileName = '' then
    begin
      if lvPL.Items.Count > 0 then
      begin
        StartPlaylist;
        exit;
      end
      else
      begin
        mnuOpenClick(Self);
        exit;
      end;
    end;

    if (mp.Mode = mpStopped) and (mp.Position = mp.Length) then
      mp.Position := 0;

    if mp.Mode = mpPaused then
      mp.Resume
    else
      mp.Play;

    SetPlayCap(csMP,false);
  end
  else
  begin
    if mp.Mode = mpPlaying then mp.Pause;
    SetPlayCap(csMP,true);
  end;

  if (ss.Active) and (ss.Sync = mp.FileName) then
    cmdPlaySSClick(Self);
end;

procedure TfrmMain.cmdPlaySSClick(Sender: TObject);
begin
  if lvSS.Items.Count = 0 then
  begin
    cmdOpenSSClick(Self);
    exit;
  end;

  if cmdPlaySS.Caption = 'Play' then
  begin
    if ss.Active then
    begin
      SetPlayCap(csSS,false);

      if (mp.Mode = mpPaused) and
       (mp.FileName = ss.Sync) then
      begin
        mp.Resume;
        SetPlayCap(csMP,false);
      end;
    end
    else StartSS(1);
  end
  else
  begin
    SetPlayCap(csSS,true);

    if (mp.Mode = mpPlaying) and
     (mp.FileName = ss.Sync) then
    begin
      mp.Pause;
      SetPlayCap(csMP,true);
    end;
  end;
end;

procedure TfrmMain.mnuPublishClick(Sender: TObject);

var slFiles,slBM,slDirs,slPL : TStringList;
    n : integer;
    Dest,s,sDir : string;
    Size,Avail : comp;
    i : TListItem;

procedure PubFile(f,d : string);
begin
  if not FileExists(f) then exit;
  Size := Size + GetFileSize(f);

  if slFiles.IndexOf(f) = -1 then
  begin
    if d = '' then
      slFiles.AddObject(f,TObjStr.Create(Dest + ExtractFilename(f)))
    else
      slFiles.AddObject(f,TObjStr.Create(Dest + d + '\' + ExtractFilename(f)));
  end;
end;

procedure PubCoverArt(f,d : string);

var z : integer;
    slPics : TFileStrings;

begin
  slPics := TFileStrings.Create(ExtractFilePath(f),'*.jpg',true,false);

  try
    for z := 0 to slPics.Count - 1 do
      PubFile(slPics[z],d);
  except
  end;

  slPics.Free;
end;

procedure MkDDir(d : string);
begin
  if not DirectoryExists(Dest + d) then MkDir(Dest + d);
end;

procedure MkRelSS(f : string);

var txtIn,txtOut : textfile;

begin
  if not FileExists(f) then exit;
  AssignFile(txtIn,f);
  Reset(txtIn);
  AssignFile(txtOut,NewExt(f,'tmp'));
  Rewrite(txtOut);

  try
    while not eof(txtIn) do
    begin
      ReadLn(txtIn,s);{imgfile}
      s := 'Images\' + ExtractFilename(s);
      WriteLn(txtOut,s);
      ReadLn(txtIn,s);{cap}
      WriteLn(txtOut,s);
      ReadLn(txtIn,s);{delay}
      WriteLn(txtOut,s);
      ReadLn(txtIn,s);{sync}
      if s <> '' then s := 'Audio\' + ExtractFilename(s);
      WriteLn(txtOut,s);
      ReadLn(txtIn,s);{repeat}
      WriteLn(txtOut,s);
      ReadLn(txtIn,s);{other}
      if s <> '' then s := 'Other\' +  ExtractFilename(s);
      WriteLn(txtOut,s);
      ReadLn(txtIn,s);{font}
      WriteLn(txtOut,s);
    end;
  except
  end;

  CloseFile(txtIn);
  CloseFile(txtOut);
  DeleteFile(f);
  RenameFile(NewExt(f,'tmp'),ExtractFilePath(f) + 'AutoPlay.fss');
end;

begin // mnuPublishClick
  if (lvPL.Items.Count = 0) and
   (lvSS.Items.Count = 0) and
   (not FileExists(edtTRFile.Text)) then
  begin
    ShowMessage('Open or create a playlist or slideshow first, or open TextReader file(s).');
    exit;
  end;

  Dest := FinalBS(GetDirectory('Output Folder'));
  if Dest = '\' then exit;
  cmdStopClick(Self);
  Size := 0;
  slBM := TStringList.Create;
  slPL := TStringList.Create;
  slDirs := TStringList.Create;
  slFiles := TStringList.Create;

  for n := 0 to lvPL.Items.Count - 1 do
  begin
    i := lvPL.Items[n];

    if lowercase(ExtractFileExt(i.Caption)) = '.fsb' then
    begin
      PubFile(i.Caption,'Soundbites');
      s := FileStr(i.Caption);
      s := copy(s,21,999);
    end
    else s := i.Caption;

    sDir := 'Audio\' + SafeName(i.SubItems[siArtist] + ' - ' + i.SubItems[siAlbum]);
    if trim(sDir) = 'Audio\-' then sDir := 'Audio\NoTag';
    if slDirs.IndexOf(sDir) = -1 then slDirs.Add(sDir);
    slPL.Add(sDir + '\' + ExtractFilename(s));
    PubFile(s,sDir);
    PubCoverArt(s,sDir);
  end;

  for n := 0 to lvSS.Items.Count - 1 do
  begin
    i := lvSS.Items[n];
    PubFile(i.Caption,'Images');
    s := i.SubItems[siSync];

    if FileExists(s) then
    begin
      if lowercase(ExtractFileExt(s)) = '.fsb' then
      begin
        PubFile(s,'Soundbites');
        s := copy(FileStr(i.SubItems[siSync]),21,999);
      end
      else s := i.SubItems[siSync];

      PubFile(s,'Audio');{skip cover art for slideshow}
    end;

    if FileExists(i.SubItems[siOther]) then
      PubFile(i.SubItems[siOther],'Other');
  end;

  if FileExists(edtTRFile.Text) then
    PubFile(edtTRFile.Text,'Text');

  PubFile(HDir + 'PubCopy.exe','');
  s := uppercase(Dest);
  Avail := DiskFree(ord(s[1]) - 64);

  if Avail <= Size then
  begin
    slBM.Free;
    slPL.Free;
    slDirs.Free;
    slFiles.Free;

    ShowMessage(FileSizeText(Size) + ' is required; ' +
     FileSizeText(Avail) + ' is available.');

    exit;
  end
  else if not Confirm('FAR',
   'Copy ' + FileSizeText(Size) + '?') then exit;

  try
    DeleteFile(Dest + 'autorun.inf');

    AddFileText(Dest + 'autorun.inf',
     '[autorun]' + CRLF +
     'OPEN=far.exe' + CRLF +
     'ICON=far.exe' + CRLF +
     'label=Free Audio Reader');

    MkDDir('Soundbites');
    MkDDir('Audio');
    MkDDir('Images');
    MkDDir('Text');
    MkDDir('Other');

    for n := 0 to slDirs.Count - 1 do
      MkDDir(slDirs[n]);

    if slPL.Count > 0 then
    begin
      slPL.SaveToFile(Dest + 'AutoPlay.m3u');
      slBM.Add('#Playlist=AutoPlay.m3u');
    end;

    if FileExists(ss.Filename) then
    begin
      CopyFile(ss.Filename,Dest + 'AutoPlay.fss');
      slBM.Add('#SSFile=AutoPlay.fss');
      slBM.Add('#SSPos=1');
    end;

    if FileExists(edtTRFile.Text) then
      slBM.Add('#TextFile=' + ExtractFilename(edtTRFile.Text));

    sb.Panels[0].Text := 'Copy';
    sb.Panels[1].Text := '- - -';

    for n := 0 to slFiles.Count - 1 do
    begin
      sb.Panels[2].Text := 'Copying file ' + IntToStr(n
       + 1) + ' of ' + IntToStr(slFiles.Count) + ' - ' +
       ExtractFilename(slFiles[n]);

      Application.ProcessMessages;
      CopyFile(slFiles[n],TObjStr(slFiles.Objects[n]).s);
    end;

    MkRelSS(Dest + 'AutoPlay.fss');
  except
  end;

  slBM.SaveToFile(Dest + '_Start.fbm');
  slBM.Clear;
  slBM.Add('far.exe /approot _Start.fbm');
  slBM.SaveToFile(Dest + '_Start.bat');
  slBM.Free;
  slPL.Free;
  slDirs.Free;
  slFiles.Free;
  RenameFile(Dest + 'PubCopy.exe',Dest + 'FAR.exe');
  sb.Panels[0].Text := 'Stopped';
  sb.Panels[2].Text := 'Published: ' + Dest;
end;

procedure TfrmMain.mnuReportClick(Sender: TObject);

const AudCount = 0;
      AudSize = 1;
      ImgCount = 2;
      ImgSize = 3;
      OthCount = 4;
      OthSize = 5;
      AlbCount = 6;
      AlbSize = 7;

var s,sDir,Artist,Album,LastArtist,LastAlbum : string;
    sl : TFileStrings;
    f : TObjFile;
    n,pct : integer;
    a : array[AudCount..AlbSize] of cardinal;

procedure TrackDetail;
begin
end;

procedure AlbumTotals;
begin
  LastAlbum := UniqueID;
end;

procedure ArtistTotals;
begin
  LastArtist := UniqueID;
end;

procedure GrandTotals;
begin
end;

begin
  sDir := GetDirectory('Base Folder');
  if sDir = '' then exit else sDir := sDir + '\';
  sb.Panels[2].Text := 'Scanning...';
  Update;
  LastArtist := UniqueID;
  LastAlbum := UniqueID;
  sl := TFileStrings.Create(s,'*.*',false,true);
  sb.Panels[2].Text := 'Grouping...';
  Update;
  sl.Sort;

  try
    for n := 0 to sl.Count - 1 do
    begin
      pct := Round(((n + 1) / sl.Count) * 100);
      sb.Panels[2].Text := 'Building (' + IntToStr(pct) + '%)';
      Application.ProcessMessages;
      s := lowercase(ExtractFileExt(sl[n]));
      f := TObjFile(sl.Objects[n]);

      if InStrSet(s,'.jpg,.bmp,.gif') then
      begin
        inc(a[ImgCount]);
        inc(a[ImgSize],f.SRec.Size);
      end
      else if InStrSet(s,'.mp3,.wav,.wma,.mid?') then
      begin
        inc(a[AudCount]);
        inc(a[AudSize],f.SRec.Size);

        if s <> '.mp3' then
        begin
          Tags.Artist := copy(sl[n],Length(sDir) + 1,999);
          Tags.Artist := copy(Tags.Artist,1,pos('\',Tags.Artist));
          Tags.Album := LastDir(sl[n]);
        end
        else Tags.LoadFromFile(sl[n]);

        Artist := trim(Tags.Artist);
        Album := trim(Tags.Album);
        if Album <> LastAlbum then AlbumTotals;
        if Artist <> LastArtist then ArtistTotals;
      end
      else
      begin
        inc(a[OthCount]);
        inc(a[OthSize],f.SRec.Size);
      end;

      TrackDetail;
    end;

    GrandTotals;
  finally
    sl.Free;
  end;
end;

end.
