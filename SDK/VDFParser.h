/******************************************************/
/**                                                  **/
/**      SDK/VDFParser.h                             **/
/**      |_ @package GO:SX Legit                     **/
/**      |_ @created 2018-08-14                      **/
/**      |_ @author André "vAx" Kalisch              **/
/**                                                  **/
/**      Copyright © 2017 @author                    **/
/**      All rights reserved.                        **/
/**                                                  **/
/******************************************************/

#ifndef SDK_VDFParser_h
#define SDK_VDFParser_h

#include "Engine/common.h"

namespace Valve {
    class KeyValue {
    public:
        KeyValue(const std::string& key, const std::string& value);
        KeyValue(std::tuple<std::string, std::string>&& data);
        const std::string& Key() const;
        const std::string& Value() const;
    
    private:
        std::string m_Key;
        std::string m_Value;
    };
    
    class Node {
    public:
        Node(const std::string& name);
        void AddChild(Node&& child);
        void AddProperty(KeyValue&& prop);
        void AddProperty(std::tuple<std::string, std::string>&& data);
        const std::vector<Node>& GetChildren() const;
        const Node GetChild(const std::string key = "") const;
        const std::vector<KeyValue>& GetProperties() const;
        const KeyValue GetProperty(const std::string key = "") const;
        const std::string& Name() const;
        
        
    private:
        std::string           m_Name;
        std::vector<Node>     m_cChilds;
        std::vector<KeyValue> m_cProperties;
    };
    
    class Parser {
    public:
        enum EFileEncoding {
            ENC_UTF8 = 0,
            ENC_UTF16_LE,
            ENC_UTF16_BE,
            ENC_UTF16_CONSUME,
            ENC_MAX
        };
    
    public:
        Parser() = default;
        std::unique_ptr<Node> Parse(const std::string& path, EFileEncoding enc = ENC_UTF16_CONSUME);
    
    private:
        std::string GetLine();
        Node ParseNode(const std::string& line);
        bool LoadFile(const std::string& path, EFileEncoding enc = ENC_UTF16_CONSUME);
    
    private:
        static std::string wstring_to_string(const std::wstring& wstr);
        static std::vector<size_t> GetQuotePositions(const std::string& line);
        static bool IsNode(const std::string& line);
        static bool IsProperty(const std::string& line);
        static std::string ExtractNodeName(const std::string& line);
        static std::tuple<std::string, std::string> ExtractKeyValue(const std::string& line);
    
    private:
        std::stringstream m_ss;
    };
}

extern std::shared_ptr<Valve::Parser> vdf;

#endif /** !SDK_VDFParser_h */
