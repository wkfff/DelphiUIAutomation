{***************************************************************************}
{                                                                           }
{           DelphiUIAutomation                                              }
{                                                                           }
{                                                                           }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}
unit DelphiUIAutomation.Desktop;

interface

uses
  generics.collections,
  DelphiUIAutomation.AutomationWindow;

type
  /// <summary>
  /// Represents the Windows 'desktop'
  /// </summary>
  TAutomationDesktop = class
  public
    /// <summary>
    ///  Gets the list of desktop windows
    /// </summary>
    class function GetDesktopWindows : TList<TAutomationWindow>;

    /// <summary>
    ///  Gets the specified desktop windows
    /// </summary>
    class function GetDesktopWindow (const title : String) : TAutomationWindow;
  end;

implementation

uses
  DelphiUIAutomation.Exception,
  DelphiUIAutomation.Automation,
  UIAutomationClient_TLB,
  sysutils;

class function TAutomationDesktop.GetDesktopWindow(const title : String): TAutomationWindow;
var
  windows : TList<TAutomationWindow>;
  window : TAutomationWindow;
  count : integer;

begin
  windows := TAutomationDesktop.GetDesktopWindows;

  for count := 0 to windows.Count -1 do
  begin
    window := windows[count];

    if (window.Name = title) then
    begin
      result := window;
      break;
    end;
  end;

  if result = nil then
    raise EDelphiAutomationException.Create('Unable to find window');
end;

class function TAutomationDesktop.getDesktopWindows: TList<TAutomationWindow>;
var
  res : TList<TAutomationWindow>;
  collection : IUIAutomationElementArray;
  condition : IUIAutomationCondition;
  element : IUIAutomationElement;
  name : WideString;
  count, length : integer;

begin
  res := TList<TAutomationWindow>.create();

  UIAuto.CreateTrueCondition(condition);

  rootElement.FindAll(TreeScope_Children, condition, collection);

  collection.Get_Length(length);

  for count := 0 to length -1 do
  begin
    collection.GetElement(count, element);
    element.Get_CurrentName(name);
 //   Writeln(name);

    res.Add(TAutomationWindow.create(element));
  end;

  result := res;
end;

end.