<template>
  <div>
    <h1>增删管理员</h1>
    <Row type="flex" justify="start">
      <Col :span="2" class="label">Username</Col>
      <Col :span="4">
        <Input v-model="admin" @keyup.enter.native="add"></Input>
      </Col>
      <Col :offset="1" :span="2">
        <Button type="primary" @click="add">Add</Button>
      </Col>
    </Row>
    <table>
      <tr>
        <th>Username</th>
        <th>Nick</th>
        <th>Remove</th>
        <th>Type</th>
      </tr>
      <template v-for="user in adminList">
        <tr :key="user.uid">
          <td>{{ user.uid }}</td>
          <td>{{ user.nick }}</td>
          <td>
            <Button v-if="user.uid !== 'admin'" type="text" @click="remove(user)">Remove</Button>
          </td>
          <td>
            <Select v-model="user.privilege" @on-change="update(user)" v-if="user.uid !== 'admin'">
              <Option v-for="item in getOptions()" :value="item.value" :key="item.value">{{ item.label }}</Option>
            </Select>
          </td>
        </tr>
      </template>
    </table>
    <Card dis-hover>
        <p>Admin 모든 권한을 가지고 있습니다.</p>
        <p>Teacher 삭제를 제외하고 모든 권한을 가지고 있습니다.</p>
        <p>일반적으로 추가된 사용자는 웹 페이지를 새로 고치거나 다시 로그인하면 새로운 권한을 볼 수 있습니다.</p>
    </Card>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import only from 'only'

export default {
  data: () => ({
    admin: ''
  }),
  computed: {
    ...mapGetters({
      adminList: 'user/adminList',
      privilege: 'privilege'
    })
  },
  created () {
    this.fetchAdmin()
  },
  methods: {
    getOptions () {
      return [{
        value: this.privilege.Teacher,
        label: 'Teacher'
      },
      {
        value: this.privilege.Root,
        label: 'Admin'
      }]
    },
    update (user) {
      const payload = only(user, 'uid privilege')
      this.$store.dispatch('user/update', payload).then(() => {
        this.$Message.success(`유저, ${payload.uid} 갱신(?) 완료！`)
        this.fetchAdmin()
        this.admin = ''
      })
    },
    fetchAdmin () {
      this.$store.dispatch('user/find', { privilege: 'admin' })
    },
    add () {
      const user = {
        uid: this.admin,
        privilege: this.privilege.Teacher
      }
      this.$store.dispatch('user/update', user).then(() => {
        this.$Message.success(`유저, ${this.admin} 관리자 수정 완료！`)
        this.fetchAdmin()
        this.admin = ''
      })
    },
    remove (item) {
      const user = Object.assign(
        only(item, 'uid nick'),
        { privilege: this.privilege.PrimaryUser }
      )
      this.$Modal.confirm({
        title: '알림',
        content: `<p>유저, ${user.uid}用户的管理员权限, 是否继续?</p>`,
        onOk: () => {
          this.$store.dispatch('user/update', user).then(() => {
            this.$Message.success(`유저, ${user.uid} 수정 완료 !`)
            this.fetchAdmin()
          })
        },
        onCancel: () => {
          this.$Message.info('수정 취소 !')
        }
      })
    }
  }
}
</script>

<style lang="stylus" scoped>
@import '../../../styles/common'

.ivu-col-offset-1
  margin-left: 1%
table
  margin-bottom: 20px
</style>
