/******************************************************/
/**                                                  **/
/**      SDK/VDFParser.mm                            **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-02                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#include "VDFParser.h"
#include <codecvt>

Valve::KeyValue::KeyValue(const std::string& key, const std::string& value) : m_Key(key), m_Value(value) {
}

Valve::KeyValue::KeyValue(std::tuple<std::string, std::string>&& data)
: m_Key(std::get<0>(data)), m_Value(std::get<1>(data)) {
}

const std::string& Valve::KeyValue::Key() const {
    return m_Key;
}

const std::string& Valve::KeyValue::Value() const {
    return m_Value;
}

Valve::Node::Node(const std::string& name) : m_Name(name) {
}

void Valve::Node::AddChild(Node&& child) {
    m_cChilds.push_back(std::move(child));
}

void Valve::Node::AddProperty(KeyValue&& prop) {
    m_cProperties.push_back(std::move(prop));
}

void Valve::Node::AddProperty(std::tuple<std::string, std::string>&& data) {
    m_cProperties.emplace_back(std::move(data));
}

const std::vector<Valve::Node>& Valve::Node::GetChildren() const {
    return m_cChilds;
}

const Valve::Node Valve::Node::GetChild(const std::string key) const {
    Valve::Node ReturnNode(key);
    if (key != "") {
        for (auto child : m_cChilds) {
            if (child.Name() == key) {
                ReturnNode = child;
                
                break;
            }
        }
    }
    
    return ReturnNode;
}

const std::vector<Valve::KeyValue>& Valve::Node::GetProperties() const {
    return m_cProperties;
}

const Valve::KeyValue Valve::Node::GetProperty(const std::string key) const {
    Valve::KeyValue ReturnProperty(key, "");
    if (key != "") {
        for (auto child : m_cProperties) {
            if (child.Key() == key) {
                ReturnProperty = child;
                
                break;
            }
        }
    }
    
    return ReturnProperty;
}

const std::string& Valve::Node::Name() const {
    return m_Name;
}

std::unique_ptr<Valve::Node> Valve::Parser::Parse(const std::string& path, EFileEncoding enc) {
    if (!LoadFile(path, enc)) {
        return nullptr;
    }
    
    auto node = ParseNode(GetLine());
    if (node.GetChildren().size() == 0 && node.GetProperties().size() == 0) {
        return nullptr;
    }
    
    m_ss.clear();
    return std::make_unique<Node>(std::move(node));
}

std::string Valve::Parser::GetLine() {
    if (!m_ss.good()) {
        return "";
    }
    
    std::string line;
    getline(m_ss, line);
    if (line.back() == '\n') {
        line.pop_back();
    }
    return line;
}

std::string Valve::Parser::wstring_to_string(const std::wstring& wstr) {
    std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>, wchar_t> converter;
    return converter.to_bytes(wstr);
}

std::vector<size_t> Valve::Parser::GetQuotePositions(const std::string& line) {
    std::vector<size_t> cPositions;
    auto           bEscape = false;
    for (size_t i = 0; i < line.size(); ++i) {
        auto c = line[i];
        if (c == '\\') {
            bEscape = bEscape ? false : true;
            continue;
        }
        if (c == '"' && !bEscape) {
            cPositions.push_back(i);
        }
        bEscape = false;
    }
    return cPositions;
}

bool Valve::Parser::IsNode(const std::string& line) {
    return GetQuotePositions(line).size() == 2;
}

bool Valve::Parser::IsProperty(const std::string& line) {
    return GetQuotePositions(line).size() == 4;
}

std::string Valve::Parser::ExtractNodeName(const std::string& line) {
    auto cPos = GetQuotePositions(line);
    if (cPos.size() != 2) {
        return line;
    }
    return line.substr(cPos[0] + 1, cPos[1] - cPos[0] - 1);
}

std::tuple<std::string, std::string> Valve::Parser::ExtractKeyValue(const std::string& line) {
    auto cPos = GetQuotePositions(line);
    if (cPos.size() != 4) {
        return std::make_tuple("Error", line);
    }
    auto key = line.substr(cPos[0] + 1, cPos[1] - cPos[0] - 1);
    auto val = line.substr(cPos[2] + 1, cPos[3] - cPos[2] - 1);
    return make_tuple(key, val);
}

Valve::Node Valve::Parser::ParseNode(const std::string& line) {
    if (!m_ss.good()) {
        return {"Error"};
    }
    
    Node node(ExtractNodeName(line));
    GetLine();
    while (m_ss.good()) {
        auto strLine = GetLine();
        if (IsNode(strLine)) {
            node.AddChild(ParseNode(strLine));
        } else if (IsProperty(strLine)) {
            node.AddProperty(ExtractKeyValue(strLine));
        } else if (strLine.find('}') != std::string::npos) {
            return node;
        }
    }
    
    return node;
}

bool Valve::Parser::LoadFile(const std::string& path, EFileEncoding enc) {
    std::wifstream FileStream(path);
    if (!FileStream || !FileStream.good()) {
        printf("[!] Could not open file '%s'", path.c_str());
        return false;
    }
    
    switch (enc) {
        case ENC_UTF8:
            FileStream.imbue(std::locale(FileStream.getloc(), new std::codecvt_utf8_utf16<wchar_t>));
            break;
        case ENC_UTF16_LE:
            FileStream.imbue(
                             std::locale(FileStream.getloc(), new std::codecvt_utf16<wchar_t, 0x10FFFF, std::little_endian>));
            break;
        case ENC_UTF16_BE:
            FileStream.imbue(std::locale(FileStream.getloc(), new std::codecvt_utf16<wchar_t, 0x10FFFF>));
            break;
        default:
        case ENC_UTF16_CONSUME:
            FileStream.imbue(
                             std::locale(FileStream.getloc(), new std::codecvt_utf16<wchar_t, 0x10FFFF, std::consume_header>));
            break;
    }
    
    std::wstring wstrBuffer((std::istreambuf_iterator<wchar_t>(FileStream)), std::istreambuf_iterator<wchar_t>());
    m_ss << wstring_to_string(wstrBuffer);
    return true;
}

std::shared_ptr<Valve::Parser> vdf = std::make_unique<Valve::Parser>();
