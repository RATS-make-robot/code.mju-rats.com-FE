<template>
  <div>
    <h1>管理用户组</h1>
    <Row type="flex" justify="start">
      <Col :span="2" class="label">Group</Col>
      <Col :span="4">
        <Select v-model="ind" filterable>
          <Option v-for="(item, index) in groupList" :value="index" :key="item.gid">{{ item.title }}</Option>
        </Select>
      </Col>
      <Col :offset="1" :span="2">
        <Dropdown @on-click="manageGroup">
          <Button type="primary">
            Manage
            <Icon type="arrow-down-b"></Icon>
          </Button>
          <DropdownMenu slot="list">
            <DropdownItem name="search">Search</DropdownItem>
            <DropdownItem name="create">Create</DropdownItem>
            <DropdownItem name="delete">Delete</DropdownItem>
          </DropdownMenu>
        </Dropdown>
      </Col>
      <Col span="2">
        <Tag>
          {{ operation }}
        </Tag>
      </Col>
    </Row>
    <Row type="flex" justify="start">
      <Col :span="2" class="label">Title</Col>
      <Col :span="4">
        <Input v-model="group.title"></Input>
      </Col>
    </Row>
    <Transfer
      :data="transData"
      :target-keys="targetKeys"
      :render-format="format"
      :list-style="listStyle"
      :operations="['To left','To right']"
      filterable
      :filter-method="filterMethod"
      @on-change="handleChange"
      class="tranfer">
    </Transfer>
    <Button type="primary" @click="saveGroup" class="submit">Submit</Button>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import only from 'only'

export default {
  data: () => ({
    ind: 0,
    targetKeys: [],
    listStyle: {
      width: '350px',
      height: '400px'
    },
    userList: [],
    operation: 'search'
  }),
  computed: {
    ...mapGetters({
      user: 'user/user',
      userSum: 'user/list',
      groupList: 'group/list',
      group: 'group/group'
    }),
    transData () {
      return this.userSum.map((item, index) => ({
        key: index + '',
        label: item.uid + ' | ' + item.nick
      }))
    }
  },
  created () {
    this.fetchGroup()
  },
  methods: {
    fetchGroup () {
      this.$Spin.showLoading()
      this.$store.dispatch('user/find')
        .then(() => {
          this.$store.dispatch('group/find')
        })
        .then(() => {
          this.userSum.forEach((item) => {
            this.userList.push(item.uid)
          })
          this.$Spin.hide()
        })
    },
    format (item) {
      return item.label
    },
    filterMethod (data, query) {
      return data.label.indexOf(query) > -1
    },
    handleChange (newTargetKeys) {
      this.targetKeys = newTargetKeys
    },
    manageGroup (name) {
      if (this.groupList.length > 0) {
        this.group.gid = this.groupList[this.ind].gid
        this.group.title = this.groupList[this.ind].title
      }
      this.operation = name
      if (name === 'search') {
        this.$Spin.showLoading()
        this.targetKeys = []
        this.$store.dispatch('group/findOne', { gid: this.group.gid }).then(() => {
          this.group.list.forEach((item) => {
            this.targetKeys.push(this.userList.indexOf(item) + '')
          })
          this.$Spin.hide()
        }).catch(() => {
          this.$Spin.hide()
        })
      } else if (name === 'create') {
        this.group.gid = ''
        this.group.title = ''
        this.group.list = []
        this.targetKeys = []
      } else if (name === 'delete') {
        if (!this.group || !this.group.gid) {
          this.$Message.info('삭제할 그룹을 선택해주세요!')
        } else {
          this.$Modal.confirm({
            title: '알림',
            content: `<p>Group--${this.group.title}, 삭제하시겠습니까?</p>`,
            onOk: () => {
              this.$Spin.showLoading()
              this.$store.dispatch('group/delete', { gid: this.group.gid }).then(() => {
                this.$Spin.hide()
                this.$Message.success(`삭제 완료, ${this.group.title}！`)
              }).catch(() => {
                this.$Spin.hide()
              })
            },
            onCancel: () => {
              this.$Message.info('삭제 취소 !')
            }
          })
        }
      }
    },
    saveGroup () {
      const user = this.targetKeys.map((item) => this.userList[+item])
      const group = Object.assign(
        only(this.group, 'gid title'),
        { list: user }
      )
      if (this.group.gid !== '') {
        this.$Spin.showLoading()
        this.$store.dispatch('group/update', group).then(() => {
          this.$Spin.hide()
          this.$Message.success('수정 완료！')
        }).catch(() => {
          this.$Spin.hide()
        })
      } else {
        this.$Spin.showLoading()
        this.$store.dispatch('group/create', group).then(() => {
          this.$store.dispatch('group/find')
          this.$Spin.hide()
          this.$Message.success('사용자 생성 완료 !')
        }).catch(() => {
          this.$Spin.hide()
        })
      }
    }
  }
}
</script>

<style lang="stylus" scoped>
.ivu-col-offset-1
  margin-left: 1%
.tranfer
  margin-top: 20px
  margin-bottom: 20px
.ivu-tag
  height: 28px
  line-height: 26px
</style>
