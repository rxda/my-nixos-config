{
  outputs = { self }: {
    templates = {
      
      rust-cross = {
        path = ./rust-cross; # 指向实际文件的子目录
        description = "Rust Cross Template";
      };

    };
  };
}